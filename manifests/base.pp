class stack_wordpress::base {
  package { gcc:
    ensure => 'present'
  }

  cron { 'puppetagent':
    user    => 'root',
    ensure  => 'present',
    command => '/usr/local/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60';
  }

  package { 'puppetdb-ruby':
    ensure   => 'installed',
    provider => 'gem',
  }
}
