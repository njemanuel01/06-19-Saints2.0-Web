require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"
# This class performs functions related to adding, updating, and deleting elements from the countries table in the saints database.
class Country
  extend DatabaseClassMethod
  include DatabaseInstanceMethod
  
  attr_accessor :id, :country_name, :country_description, :errors
  # Creates an instance of the Country class.
  #
  # values - hash with "id", "country_name", and "country_description" values
  def initialize(values = {})
    @id = values["id"].to_i
    @country_name = values["country_name"]
    @country_description = values["country_description"]
    @errors = []
  end
  
  # Adds a new country to the countries table
  #
  # Returns a Boolean.
  def add_to_database
    if self.valid?
      CONNECTION.execute("INSERT INTO countries (country_name, country_description) VALUES (?, ?);", @name, @description)
      @id = CONNECTION.last_insert_row_id
    else
      false
    end
  end
  
  # Checks to see if a country already exists in the table
  #
  # Returns a Boolean.
  def valid?
    array = self.class.all
    array.each do |country|
      if @name == country.name
        @errors << "This country already exists."
      end
    end
    
    return @errors.empty?
  end
   
end

  