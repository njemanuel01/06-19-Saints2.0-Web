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
  
  # Adds a new category to the categories table
  #
  # Returns a Boolean.
  def add_to_database
    if self.valid?
      CONNECTION.execute("INSERT INTO categories (category_name) VALUES (?);", @category_name)
      @id = CONNECTION.last_insert_row_id
    else
      false
    end
  end
  
  # Checks to see if a category already exists in the table
  #
  # Returns a Boolean.
  def valid?
    array = self.class.all
    array.each do |category|
      if @cateogry_name == category.name
        @errors << "This category already exists."
      end
    end
    
    return @errors.empty?
  end
  
end