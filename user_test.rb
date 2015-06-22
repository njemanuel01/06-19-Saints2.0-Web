require "minitest/autorun"
require_relative "category.rb"

class CategoryTest < Minitest::Test
  #test the valid? method returns a correct boolean
  def test_valid?
    hash = {"user_name" => "test_user", "password" => "test_password"}
    test = User.new(hash)
    assert(test.valid?)
  end
  
  #test the valid_password method
  def test_valid_password?
    hash = {"user_name" => "test_user", "password" => "test_password"}
    test = User.new(hash)
    password = "test_password"
    assert(test.valid_password?(password))
  end
  
end