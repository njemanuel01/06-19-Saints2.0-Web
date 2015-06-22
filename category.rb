require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"
# This class performs functions related to adding, updating, and deleting elements from the categories table in the saints database.
class Category
  extend DatabaseClassMethod
  include DatabaseInstanceMethod
  
  attr_accessor :id, :category_name, :errors
  # Creates an instance of the Category class.
  #
  # values - hash with "id" and "category_name" values
  def initialize(values = {})
    @id = values["id"].to_i
    @category_name = values["category_name"]
    @errors = []
  end
  
  # Checks to see if a category already exists in the table
  #
  # Returns a Boolean.
  def valid?
    array = self.class.all
    array.each do |category|
      if @category_name == category.category_name
        @errors << "This category already exists."
      end
    end
    
    return @errors.empty?
  end
  
end