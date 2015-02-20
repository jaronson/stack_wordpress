class stack_wordpress {
}

class stack_wordpress::app {
  cron { 'puppetagent':
    user    => 'root',
    ensure  => 'present',
    command => '/usr/local/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60';
  }

  class { 'apache':
    docroot => $::app_root
  }
  include apache::mod::php

  class { 'mysql::bindings':
    php_enable => true
  }

  class { 'wordpress':
    install_dir => $::app_root,
    db_host     => $::db_host, # Provided by stack_wordpress_db_host facter
    db_user     => $::db_user,
    db_password => $::db_pass,
  }
}
