require 'rake'
require './app'
# import './tasks/db_create.rake'
Dir.glob('tasks/*.rake').each { |r| load r }

task :default do  
end

task :test do
  require './app'
  Dir['./test/**/*_test.rb'].each { |test| p test;   require test }
end
