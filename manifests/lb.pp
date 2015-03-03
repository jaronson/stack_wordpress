class stack_wordpress::lb {
  include stack_wordpress::base

  class { 'haproxy': }

  haproxy::frontend { 'localnodes':
    ipaddress => '0.0.0.0',
    ports => '80',
    mode => 'http',
    options => {
      'default_backend' => $::stack_name,
    },
  }

  haproxy::backend { $::stack_name:
    collect_exported => true,
    options => {
      'mode' => 'http'
    }
  }
}
