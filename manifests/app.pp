class stack_wordpress::app(
  $app_root => '/opt/wp',
  $db_user  => 'wordpress',
  $db_pass  => 'strongpass',
){
  include stack_wordpress::base

  class { 'apache':
    docroot => $app_root
  }

  class { 'apache::mod::php': }

  class { 'mysql::client': }

  class { 'mysql::bindings':
    php_enable => true
  }

  class { 'wordpress':
    install_dir => $app_root,

    # Provided by stack_wordpress_db_host facter
    db_host     => $::stack_db_ip,

    db_user     => $db_user,

    db_password => $db_pass,
  }
}
