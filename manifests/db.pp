class stack_wordpress::db (
  $root_password = 'strongpass'
) {
  include stack_wordpress::base

  class { 'mysql::server':
    root_password => $root_password,
    override_options => {
      'mysqld' => {
        'bind-address' => '0.0.0.0'
      }
    }
  }

  file { '/tmp/mysql_users.sql':
    ensure  => 'present',
    content => template('stack_wordpress/mysql_users.sql'),
    require => Class['mysql::server']
  }

  mysql_database { 'wordpress':
    ensure  => 'present',
    charset => 'utf8',
  }

  exec { 'create mysql users':
    command => "mysql -uroot -p${root_password} < /tmp/mysql_users.sql",
    path    => '/usr/bin',
    require => File['/tmp/mysql_users.sql'],
  }
}
