
require 'minitest/autorun'
require 'rack/test'
require './test/factories/user'

ENV['RACK_ENV'] = 'test'

class MiniTest::Spec
  include FactoryGirl::Syntax::Methods
end

require File.expand_path '../../app.rb', __FILE__