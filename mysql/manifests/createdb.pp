define mysql::createdb (
  $user = 'root',
  $password,
  $source = 'none',
) {
#   mysql
  $sql_cli = "${mysql::params::sql_cli}"
  $sql_dump = "${mysql::params::sql_dump}"
  if ( $source == 'none' ) {
	  exec { "createdb-$name":
	    require => Class["mysql::service"],
	    command => "${mysql::params::sql_cli} -u${user} -p${password} -e \"create database ${name};\" ",
	    unless => "${mysql::params::sql_cli} -u${user} -p${password} ${name}",
	  }
  }

  if ( $source != 'none' ) {
	file {"/root/dbinit-$name":
		content => template("mysql/dbinit.sh"),
		mode => '0700',
		owner => 'root',
		ensure => file,
	} ->
	file {"/root/schema-$name":
		ensure => file,
		owner => 'root',
		mode => '0500',
		source => "puppet:///modules/mysql/$source",
	} ->
          exec { "createdb-with-schema-$name":
            require => [ Class["mysql::service"], File["/root/dbinit-$name"], File["/root/schema-$name"] ],
            command => "/root/dbinit-$name",
            unless => "${mysql::params::sql_cli} -u${user} -p${password} ${name}",
          }
  }

  mysql::backupdb { $name :
     password => "$password",
  }
}

