class mysql::params {
  case $::operatingsystem {
    'CentOS': {
      if $::operatingsystemmajrelease == '7' {
          $pkg_name = ["mariadb-server"]
          $service_name = 'mariadb'
      } else {
          $pkg_name = ["mysql-server"]
          $service_name = 'mysqld'
      }
#      $conf_file = '/etc/my.cnf.d/automy.cnf'
      $conf_file = '/etc/my.cnf'
      $conf_file_owner = 'root'
      $conf_file_group = 'root'
      $sql_cli = '/usr/bin/mysql'
      $sql_dump = '/usr/bin/mysqldump'
      $echo_cli = '/bin/echo'
      # template for mysql params
      if $::mysql::usecrmcnf == 'yes' {
          $conf_template = "mysql/autoconf-crm.cnf.erb"
      } else {
          $conf_template = "mysql/autoconf.cnf.erb"
      }
      # template for database backup
      $dbbackup_template = "mysql/backupdb.sh.erb"
      # script directory
      $script_dir = "/root/script"
    }
    default: { notice("Your OS does not support by thi module.") }
  }
  $mysql_secure = "DELETE FROM mysql.user WHERE User=\'\';
DELETE FROM mysql.user WHERE User=\'root\' AND Host NOT IN (\'localhost\', \'127.0.0.1\', \'::1\');
DELETE FROM mysql.db WHERE Db=\'test\' OR Db=\'test\\\\_%\';
UPDATE mysql.user SET Password=PASSWORD(\'${::mysql::password}\') WHERE User=\'root\';
FLUSH PRIVILEGES;"
}
