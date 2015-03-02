class stack_wordpress::lb {
  include stack_wordpress::base

  class { 'haproxy': }

  haproxy::frontend { 'localnodes':
    ipaddress => '0.0.0.0',
    ports => '80',
    mode => 'http',
    options => {
      'default_backend' => 'stack00'
    },
  }

  haproxy::backend { 'stack00':
    collect_exported => true,
    options => {
      'mode' => 'http'
    }
  }
}
