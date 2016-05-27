class httpd::install {
  include httpd::params
  package { $::httpd::params::pkg_name:
    ensure => present,
    require => Class["httpd::params"],
#    name => $::httpd::params::pkg_name,
  }
}
