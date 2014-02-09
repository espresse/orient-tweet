require 'singleton'

class Database
  include Singleton
  attr_accessor :database

  def initialize
    srv = {host: 'localhost', port: 2424}
    @database = OrientdbBinary::Database.new(srv)
    @database.open(db: 'GratefulDeadConcerts', user: "admin", password: "admin", storage: 'plocal')
  end
end