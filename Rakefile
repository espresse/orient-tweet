Dir.glob('tasks/*.rake').each { |r| load r }

task default: :test

task :test do
  Dir['./test/**/*_test.rb'].each { |test| p test;   require test }
end
