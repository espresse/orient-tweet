require 'singleton'

class Database
  include Singleton
  attr_accessor :database

  def initialize
    settings = YAML::load_file(File.join(__dir__, '..', 'config', 'database.yml'))
    set = setings[:database][ENV['RACK_ENV'].to_sym]
    @database = OrientdbBinary::Database.new(host: set['host'], port: set['port'])
    @database.open db: set['db'], user: set['db_user'], password: set['db_password'], storage: set['storage']
  end
end