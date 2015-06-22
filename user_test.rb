require "minitest/autorun"
require_relative "category.rb"

class CategoryTest < Minitest::Test
  #test the valid? method returns a correct boolean
  def test_valid?
    hash = {"user_name" => "test_user"}
    test = User.new(hash)
    assert(test.valid?)
  end
end