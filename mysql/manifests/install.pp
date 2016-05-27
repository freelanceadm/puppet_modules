class mysql::install {
  include mysql::params
  package { $::mysql::params::pkg_name :
    ensure => present,
    require => Class["mysql::params"]
  }
}
