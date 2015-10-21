# == Class: sentry::install
#
# Installs Sentry from pip into a virtualenv
#
# === Params
#
# admin_email: Sentry admin user email address
# admin_password: Sentry admin user password
# group: UNIX group to own Sentry files
# organization: default Sentry organization to create
# path: path into which to create virtualenv and install Sentry
# project: initial Sentry project to create
# team: default Sentry team to create
# user: UNIX user to own Sentry files
# version: version of Sentry to install
#
# === Authors
#
# Dan Sajner <dsajner@covermymeds.com>
# Scott Merrill <smerrill@covermymeds.com>
#
# === Copyright
#
# Copyright 2015 CoverMyMeds
#
class sentry::install (
  $admin_email    = $sentry::admin_email,
  $admin_password = $sentry::admin_password,
  $group          = $sentry::group,
  $organization   = $sentry::organization,
  $path           = $sentry::path,
  $project        = $sentry::project,
  $team           = $sentry::team,
  $user           = $sentry::user,
  $version        = $sentry::version,
) {

  group { $group:
    ensure => present,
  }

  user { $user:
    ensure  => present,
    gid     => $group,
    home    => '/dev/null',
    shell   => '/bin/false',
    require => Group[$group],
  }

  file { '/var/log/sentry':
    ensure  => directory,
    owner   => 'sentry',
    group   => 'sentry',
    mode    => '0755',
    require => User[$user],
  }

  # Setup log rotation for the sentry-worker process
  logrotate::rule { 'sentry-worker':
    ensure       => present,
    path         => '/var/log/sentry/sentry-worker.log',
    create       => true,
    compress     => true,
    missingok    => true,
    rotate       => 14,
    ifempty      => false,
    create_mode  => '0644',
    create_owner => $user,
    create_group => $group,
  }

  $rpm_dependencies = [
    'libffi-devel',
    'libxml2-devel',
    'libxslt-devel',
    'openldap-devel',
    'openssl-devel',
    'zlib-devel',
  ]

  ensure_packages( $rpm_dependencies )

  python::virtualenv { $path:
    ensure  => present,
    owner   => $user,
    group   => $group,
    version => 'system',
  }

  Python::Pip {
    ensure     => present,
    virtualenv => $path,
  }

  $pip_dependencies = [
    'django_auth_ldap',
    'hiredis',
    'nydus',
    'psycopg2',
    'python-memcached',
    'python-ldap',
    'redis',
  ]

  python::pip { $pip_dependencies: }

  python::pip { 'sentry':
    ensure => $version,
  }

  # we install this *after* Sentry to ensure that a newer version of
  # Sentry is installed.  This only requires 4.3.0, so Pip's dependency
  # resolution may may install an older version of Sentry, which would
  # then be promptly upgraded.
  python::pip { 'sentry-ldap-auth':
    require => Python::Pip['sentry'],
  }

  # this exec will handle creating a new database, as well as upgrading
  # an existing database.  The `creates` parameter is version-specific,
  # so this should run automatically on version upgrades.
  exec { 'sentry-database-install':
    command => "${path}/bin/sentry --config=${path}/sentry.conf upgrade --noinput > ${path}/install-${version}.log 2>&1",
    creates => "${path}/install-${version}.log",
    path    => "${path}/bin:/bin:/usr/bin",
    user    => $user,
    group   => $group,
    cwd     => $path,
    require => [ Python::Pip['sentry'], User[$user], ],
  }

  # the `creates` log file is not version-specific, so as to ensure
  # this only runs once, upon initial installation.
  # Note: A failure here is catastrophic, and will prevent additional
  # Sentry configuration.
  exec { 'sentry-create-admin':
    command => "${path}/bin/sentry --config=${path}/sentry.conf createuser --superuser --email=${admin_email} --password=${admin_password} --no-input > ${path}/admin-${admin_email}.log 2>&1",
    creates => "${path}/admin-${admin_email}.log",
    path    => "${path}/bin:/usr/bin:/usr/sbin:/bin",
    require => Exec['sentry-database-install'],
  }

  file { "${path}/bootstrap.py":
    ensure  => present,
    mode    => '0744',
    content => template('sentry/bootstrap.py.erb'),
    require => Exec['sentry-create-admin'],
  }

  exec { 'sentry-bootstrap':
    command => "${path}/bootstrap.py",
    creates => "${path}/bootstrap.log",
    path    => "${path}/bin:/usr/bin/:/usr/sbin:/bin",
    require => File["${path}/bootstrap.py"],
  }

  file { "${path}/dsn":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $group,
    require => File["${path}/bootstrap.py"],
  }

}