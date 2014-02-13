require 'singleton'
require 'yaml'
require 'orientdb_binary'

module Oriental
  class Database
    include Singleton
    attr_accessor :database

    def initialize
      settings = YAML::load_file(File.join(__dir__, '..', 'config', 'database.yml'))
      set = settings["database"][ENV['RACK_ENV']]
      @database = OrientdbBinary::Database.new(host: set['host'], port: set['port'])
      @database.open db: set['db'], user: set['db_user'], password: set['db_password'], storage: set['storage']
    end
  end
end
