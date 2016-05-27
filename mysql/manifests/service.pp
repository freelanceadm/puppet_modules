class mysql::service {
  include mysql::params
#  include mysql::config
  service { $::mysql::params::service_name :
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Class["mysql::config"],
  }
### setup our server to be more secure
### if you can login to mysql with root user without password
### then run secure installation
### and set root password to password from manifest
  exec {"secure_sql_installation":
#    command => "${mysql::params::sql_cli} -u${mysql::user} < ${mysql::params::mysql_secure}",
    command => "${mysql::params::echo_cli} \"${mysql::params::mysql_secure}\" | ${mysql::params::sql_cli} -u${mysql::user}",
    onlyif => "${mysql::params::sql_cli} -u${mysql::user}",
    require => Service["$::mysql::params::service_name"],
  }
}
