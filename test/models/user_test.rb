require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "User" do

  describe "attributes" do
    it "should have rid" do
      assert_instance_of Virtus::Attribute, User.attribute_set[:rid]
    end

    it "should have username" do
      assert_instance_of Virtus::Attribute, User.attribute_set[:username]
    end

    it "should have email" do
      assert_instance_of Virtus::Attribute, User.attribute_set[:email]
    end

    it "should have crypted_pass" do
      assert_instance_of Virtus::Attribute, User.attribute_set[:crypted_pass]
    end
  end

  describe "modules" do
    it "should includes Oriental::Graph::Edge" do
      assert User.included_modules.include? Oriental::Graph::Edge
    end
  end

  describe "new" do

    it "should be not valid without password" do
      user = build(:user)
      assert !user.valid?
    end

    it "should be valid with password" do
      user = build(:valid_user)
      assert user.valid?
    end
  end
end