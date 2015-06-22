require "minitest/autorun"
require_relative "category.rb"

class CategoryTest < Minitest::Test
  #test the valid? method returns a correct boolean
  def test_valid?
    hash = {"country_name" => "test_country"}
    test = Country.new(hash)
    assert(test.valid?)
  end
end