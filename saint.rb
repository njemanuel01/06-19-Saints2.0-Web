require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"
# This class performs functions related to adding, updating, and deleting elements from the saints table in the saints database.
class Saint
  extend DatabaseClassMethod
  include DatabaseInstanceMethod
  
  attr_accessor :id, :saint_name, :canonization_year, :description, :category_id, :country_id
  # Creates an instance of the Saint class.
  #
  # values - hash with "id", "saint_name", "canonization_year", "description", "category_id", and "country_id" values
  def initialize(values = {})
    @id = values["id"].to_i
    @saint_name = values["saint_name"]
    @canonization_year = values["canonization_year"].to_i
    @description = values["description"]
    @category_id = values["category_id"]
    @country_id = values["country_id"]
  end
  
  # Gets a list of saints with a particular keyword in the description.
  #
  # keyword - string value
  #
  # Return an Array of Student objects or string.
  def self.where_keyword(keyword)
    saint_array = []
    array = self.all
    array.each do |saint|
      string_array = saint.description.split
      if (string_array.include?(keyword) || string_array.include?(keyword.capitalize))
        saint_array << saint
      end
    end
    
    return saint_array
  end
    
end