define httpd::vhost(
  $docroot,
  $port='80',
  $sslport = '443',
  $serveraliases='',
  $template='httpd/vhost.conf.erb',
  $templatessl = 'httpd/vhostssl.conf.erb',
  $filename='',
  $ssl = 'no',
  $certname = 'no',
){
  include httpd

### file for common options ( they are the same for all domains)
# moved to config.pp
#  file { "${::httpd::params::conf_dir}/main.conf":
#    content => template("httpd/main.conf.erb"), 
#  }
  if $filename != '' {
    $confname = "$filename"
  } else {
    $confname = "$name.conf"
  }

### virtual host config 
if $template != 'httpd/vhost.conf.erb' {
  file { "${::httpd::params::conf_dir}/${confname}":
    content => template($template),
    owner => 'root',
    group => 'root',
    mode => '0644',
    require => Class['httpd::install'],
    notify => Class['httpd::service'],
  }
} else {  
  file { "${::httpd::params::conf_dir}/${confname}":
    content => template($template),
    owner => 'root',
    group => 'root',
    mode => '0644',
    require => Class['httpd::install'],
    notify => Class['httpd::service'],
  }
}
### create ssl vhosts
if $ssl != 'no' {
  file { "${::httpd::params::conf_dir}/ssl${confname}":
    content => template($templatessl),
    owner => 'root',
    group => 'root',
    mode => '0644',
    require => Class['httpd::install'],
    notify => Class['httpd::service'],
  }
  if $certname != 'no' {
    file {"${::httpd::params::cert_crt}${name}.crt":
	ensure => file,
        owner => 'root',
        group => 'root',
        mode => '0400',
	source => "puppet:///modules/httpd/$name.crt",
    }

    file {"${::httpd::params::cert_key}${name}.key":
        ensure => file,
        source => "puppet:///modules/httpd/$name.key",
        owner => 'root',
        group => 'root',
        mode => '0400',
    }

  }
}

### create directory for vhost
  if defined(File["$docroot"]) {
  
  } else {
  file { "$docroot":
        path => "$docroot",
	owner => "${::httpd::params::apache_usr}",
	group => "${::httpd::params::apache_usr}",
	mode => '2775',
	ensure => directory,
	require => [ Class['httpd::install'], Exec["create_dir_$docroot"]],  
  }
  }
  exec {"make_writable_$docroot":
    command => "/usr/bin/setfacl -d -m group::rwx $docroot",
    subscribe => File["$docroot"],
  }

  exec {"create_dir_$docroot":
    command => "${::httpd::params::mkdirpath} -p $docroot",
  }

}
