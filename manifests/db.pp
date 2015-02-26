class stack_wordpress::db {
  include stack_wordpress::base

  class { 'mysql::server':
    root_password => 'strongpass',
  }

  file { '/tmp/mysql_users.sql':
    ensure  => 'present',
    content => template('stack_wordpress/mysql_users.sql'),
    require => Class['mysql::server']
  }
}
