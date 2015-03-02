class stack_wordpress::lb {
  include stack_wordpress::base

  class { 'haproxy': }

  haproxy::listen { 'stack00':
    collect_exported => true,
    ipaddress        => '0.0.0.0',
    ports            => '80',
  }
}
