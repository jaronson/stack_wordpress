lass stack_wordpress::db (
  $root_password = 'strongpass',
  $db_user = 'wordpress',
) {
  include stack_wordpress::base

  class { 'mysql::server':
    restart => true,
    root_password => $root_password,
    override_options => {
      'mysqld' => {
        'bind-address' => '0.0.0.0'
      }
    }
  }

  resources { 'firewall':
    purge => true
  }

  firewall { '100 allow mysql access':
    port => [3306],
    proto => tcp,
    action => accept
  }

  file { '/tmp/mysql_users.sql':
    ensure  => 'present',
    content => template('stack_wordpress/mysql_users.sql.erb'),
    require => Class['mysql::server']
  }

  mysql_database { 'wordpress':
    ensure  => 'present',
    charset => 'utf8',
  }

  mysql_user { 'wordpress@%':
    ensure                   => 'present',
    password_hash            => mysql_password ('strongpass'),
  }

  mysql_grant { 'wordpress@%/wordpress.*':
    ensure     => 'present',
    user       => 'wordpress@%',
    table      => 'wordpress.*',
    privileges => ['ALL'],
    }



  exec { 'create mysql users':
    command => "mysql -uroot -p${root_password} < /tmp/mysql_users.sql",
    path    => '/usr/bin',
    require => File['/tmp/mysql_users.sql'],
  }
}