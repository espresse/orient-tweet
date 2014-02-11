require 'yaml'
require './app'

namespace :db do
  desc "Create database"
  task :create do
    settings = YAML::load_file(File.join(__dir__, '..', 'config', 'database.yml'))

    settings["database"].each do |env, set|
      server = OrientdbBinary::Server.new(host: set['host'], port: set['port'])
      server.connect(user: set['server_user'], password: set['server_password'])

      unless server.db_exists? set['db']
        server.db_create(set['db'], set['type'], set['storage'])
      end

      server.disconnect
    end
  end
end