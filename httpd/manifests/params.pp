class httpd::params {
  case $::operatingsystem {
    'CentOS': {
      $pkg_name = ["httpd", "mod_ssl"]
      $service_name = "httpd"
      $conf_dir = "/etc/httpd/conf.d"
      $apache_usr = "apache"
      $cert_crt = "/etc/pki/tls/certs/"
      $cert_key = "/etc/pki/tls/private/"

    if ( $::operatingsystemmajrelease == '7' ) or ( $::lsbmajdistrelease == '7' ) {
        $mkdirpath = "/usr/bin/mkdir"
    } else {
        $mkdirpath = "/bin/mkdir"
    }

    }
    default: { notice("This module does not support your OS type.") }
  }
}
