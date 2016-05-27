class sentry::params {
  $admin_email       = 'root@localhost'
  $admin_password    = 'admin'
  $admin_user        = 'admin'
  $custom_config     = undef
  $custom_settings   = undef
  $db_host           = 'localhost'
  $db_name           = 'sentry'
  $db_password       = 'sentry'
  $db_port           = '5432'
  $db_user           = 'sentry'
  $extensions        = []
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
  $memcached_host    = 'localhost'
  $memcached_port    = '11211'
  $organization      = 'Default'
  $path              = '/srv/sentry'
  $project           = 'Default'
  $redis_host        = 'localhost'
  $redis_port        = '6379'
  $secret_key        = fqdn_rand_string(50)
  $smtp_host         = 'localhost'
  $ssl_ca            = undef
  $ssl_chain         = undef
  $ssl_cert          = '/etc/pki/tls/certs/localhost.crt'
  $ssl_key           = '/etc/pki/tls/private/localhost.key'
  $team              = 'Default'
  $url               = undef
  $user              = 'sentry'
  $version           = 'latest'
  $vhost             = $::fqdn
  $wsgi_processes    = 1
  $wsgi_threads      = 15
}
