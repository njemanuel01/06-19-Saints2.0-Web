require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"
# This class performs functions related to adding and viewing elements from the changes table in the saints database.
class Change
  extend DatabaseClassMethod
  include DatabaseInstanceMethod
  
  attr_accessor :id, :change_description, :user_id
  # Creates an instance of the Change class.
  #
  # values - hash with "id", "change_description", and "user_id" values
  def initialize(values = {})
    @id = values["id"].to_i
    @change_description = values["change_description"]
    @user_id = values["user_id"]
  end
  
end