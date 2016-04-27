class sentry::params {
  $admin_email       = 'root@localhost'
  $admin_password    = 'admin'
  $admin_user        = 'admin'
  $beacon            = false
  $db_host           = 'localhost'
  $db_name           = 'sentry'
  $db_password       = 'sentry'
  $db_port           = '5432'
  $db_user           = 'sentry'
  $group             = 'sentry'
  $ldap_auth_version = 'present'
  $ldap_base_ou      = undef
  $ldap_domain       = undef
  $ldap_group_base   = undef
  $ldap_group_dn     = undef
  $ldap_host         = undef
  $ldap_password     = undef
  $ldap_user         = undef
  $ldap_member_type  = 'ADMIN'
  $max_epm           = 500
  $max_http_body     = 16384
  $max_stacktrace    = 200
  $memcached_host    = 'localhost'
  $memcached_port    = '11211'
  $organization      = 'Default'
  $path              = '/srv/sentry'
  $percent_limit     = '90%'
  $project           = 'Default'
  $redis_host        = 'localhost'
  $redis_port        = '6379'
  $secret_key        = fqdn_rand_string(40)
  $smtp_host         = 'localhost'
  $ssl_ca            = undef
  $ssl_chain         = undef
  $ssl_cert          = '/etc/pki/tls/certs/localhost.crt'
  $ssl_key           = '/etc/pki/tls/private/localhost.key'
  $team              = 'Default'
  $user              = 'sentry'
  $version           = 'latest'
  $vhost             = $::fqdn
  $wsgi_processes    = 1
  $wsgi_threads      = 15
  $extensions        = []
}
