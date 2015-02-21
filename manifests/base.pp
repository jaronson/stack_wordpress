class stack_wordpress::base {
  cron { 'puppetagent':
    user    => 'root',
    ensure  => 'absent',
    command => '/usr/local/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60';
  }

  package { 'puppetdb-ruby':
    ensure   => 'installed',
    provider => 'gem',
  }
}
