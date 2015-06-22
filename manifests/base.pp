class stack_wordpress::base {


   package { gcc:
    ensure => 'installed'
  }

   package { make:
    ensure => 'installed'
  }

  cron { 'puppetagent':
    user    => 'root',
    ensure  => 'present',
    command => '/opt/dcm-agent-extras/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60 --confdir /opt/dcm-agent-extras/puppetconf/',
    environment => ['SHELL=/bin/bash', 'PATH="/opt/dcm-agent-extras/embedded/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"' ];
  }

  package { 'puppetdb-ruby':
    ensure   => 'installed',
    provider => 'gem',
  }
}