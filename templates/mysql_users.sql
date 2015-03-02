<%-
  require 'json'

  apps = scope.lookupvar('::stack_apps')

  if apps
    apps = JSON.parse(apps)

    apps.each do |app|
      parameters = app['catalog']['data']['resources'].detect {|res|
        res['type'] == 'Wordpress::Instance::Db'
      }['parameters']
-%>
GRANT ALL ON wordpress.* TO '<%= parameters['db_user'] %>'@'<%= app['public_ip'] %>' IDENTIFIED BY '<%= parameters['db_password'] %>';
<%- end -%>
FLUSH PRIVILEGES;
<%- end -%>
