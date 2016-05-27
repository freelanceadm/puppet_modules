class httpd::service {
  service { "$::httpd::params::service_name":
    ensure => "running",
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Class["httpd::install"],
    subscribe => Class["httpd::config"],
  }
}
