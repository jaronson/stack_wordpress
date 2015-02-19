class stack_wordpress {
}

class stack_wordpress::app {
  cron { 'puppetagent':
    user    => 'root',
    ensure  => 'present',
    command => '/usr/local/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60';
  }

  class { 'apache':
    docroot => $install_dir
  }

  include apache::mod::php
}
