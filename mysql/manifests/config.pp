class mysql::config {
  include mysql::params
#  file { "cfile":
#    ensure => present,
#    name => "$::mysql::params::conf_file",
#    require => Class["mysql::install"],
#    owner => "$::mysql::params::conf_file_owner",
#    group => "$::mysql::params::conf_file_group",
#    mode => "0644",
#    source => "puppet:///modules/mysql/my.cnf",
#    notify => Class["mysql::service"],
#  }
  file { "cfile":
    ensure => present,
    name => "$::mysql::params::conf_file",
    require => Class["mysql::install"],
    owner => "$::mysql::params::conf_file_owner",
    group => "$::mysql::params::conf_file_group",
    mode => "0644",
    notify => Class["mysql::service"],
    content => template($::mysql::params::conf_template),
  }
  file { "$::mysql::params::script_dir":
    ensure => directory,
    require => Class["mysql::install"],
    owner => "root",
    group => "root",
    mode => "0700",
  }
}


