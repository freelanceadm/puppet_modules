define mysql::backupdb (
  $user = 'root',
  $password,
  $backupdir = '/backup',
) {

  $sql_cli = "${mysql::params::sql_cli}"
  $sql_dump = "${mysql::params::sql_dump}"

    cron { "$name":
	require => Class["mysql::service"],
	command => "${::mysql::params::script_dir}/$name-backup.sh",
	user => 'root',
	minute => '3',
	hour => '23',
	weekday => [ 1, 2, 3, 4, 5 ],
    }

  file { "${::mysql::params::script_dir}/$name-backup.sh":
    ensure => present,
    require => Class["mysql::service"],
    owner => "root",
    group => "root",
    mode => "0700",
    content => template($::mysql::params::dbbackup_template),
  }

}
