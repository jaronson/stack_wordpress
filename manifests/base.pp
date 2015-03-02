class stack_wordpress::base {

  cron { 'puppetagent':
    user    => 'root',
    ensure  => 'present',
    command => '/usr/local/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60';
  }

  package { gcc:
    ensure => 'present'
  }
  ->
  exec { 'install puppetdb-ruby':
    command => 'gem install puppetdb-ruby',
    path => '/opt/puppet/bin'
  }
}
