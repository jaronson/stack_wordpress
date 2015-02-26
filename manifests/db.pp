class stack_wordpress::db {
  include stack_wordpress::base

  class { 'mysql::server':
    root_password => 'strongpass',
  }

  exec { "create mysql users":
    command => template('mysql_users.erb'),
    path    => '/usr/bin:/bin:/usr/sbin',
  }
}
