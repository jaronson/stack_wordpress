class stack_wordpress::db {
  include stack_wordpress::base

  class { 'mysql::server'
    root_password => 'strongpass',
  }
}
