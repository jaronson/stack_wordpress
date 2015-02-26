class stack_wordpress::db {
  class { 'mysql::server'
    root_password => 'strongpass',
  }
}
