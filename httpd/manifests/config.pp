class httpd::config {
  file { "${::httpd::params::conf_dir}/main.conf":
    content => template("httpd/main.conf.erb"),
  }

}
