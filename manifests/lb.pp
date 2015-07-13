class stack_wordpress::lb {
  include stack_wordpress::base

  class { 'haproxy': }

  haproxy::listen { 'stats':
    ports     => '1936',
    options   => {
      'mode'  => 'http',
      'stats' => [
      'enable','hide-version','realm Haproxy\ Statistics',
      'uri /','auth admin:Password12'

    ],
  },
}

  haproxy::listen { 'stack00':
    collect_exported => true,
    mode              => 'http',
    ipaddress        => '0.0.0.0',
    ports            => '80',
    options   => {
    'option'  => [
      'tcplog','httpclose','forwardfor'],
  }
 }

  exec { "restart_haproxy":
    command => "/etc/init.d/haproxy restart"
  }
}