require 'yaml'

def modules
  Module.constants.select do |constant_name|
    constant = eval constant_name.to_s
    
    if not constant.nil? and constant.is_a? Class and (constant.included_modules & [Oriental::Graph::Edge, Oriental::Document]).length > 0
      constant
    end
  end
end


namespace :db do
  desc "Create database"
  task :migrate do
    settings = YAML::load_file(File.join(__dir__, '..', 'config', 'database.yml'))
    settings["database"].each do |env, set|
      database = OrientdbBinary::Database.new(host: set['host'], port: set['port'])
      database.open db: set['db'], user: set['db_user'], password: set['db_password'], storage: set['storage']
      modules.each do |m|
        mod = eval m.to_s

        # mod.attribute_set.each do |a|
        #   name = a.options[:name]
        #   default = a.options[:default_value]
        #   type = a.options[:coercer].type
        # end

        # create model in db
        query = "create class #{mod.to_s}"
        query += " extends E" if mod.included_modules.include? Oriental::Graph::Edge
        query += " extends V" if mod.included_modules.include? Oriental::Graph::Vertex

        database.command query
      end

      database.close
    end
  end
end
