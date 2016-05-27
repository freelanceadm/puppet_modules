define mysql::createusr (
  $admpass,
  $password,
  $db,
) {
#  include mysql
  $cmdaddusr = "CREATE USER \'${name}\'@\'localhost\' IDENTIFIED BY \'${password}\';
GRANT ALL ON ${db}.* TO \'${name}\'@\'localhost\';
FLUSH PRIVILEGES;"

  exec {"createdbusr-${name}":
    unless => "${mysql::params::sql_cli} -u${name} -p${password} ${db}",
    require => Class["mysql::service"],
    command => "${mysql::params::sql_cli} -uroot -p${admpass} -e \"${cmdaddusr}\" ",
    onlyif => "${mysql::params::sql_cli} -uroot -p${admpass} ${db}",
  }
}

