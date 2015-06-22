require "minitest/autorun"
require_relative "category.rb"

class CategoryTest < Minitest::Test
  #test the valid? method returns a correct boolean
  def test_valid?
    hash = {"category_name" => "test_category"}
    test = Category.new(hash)
    assert(test.valid?)
  end
end