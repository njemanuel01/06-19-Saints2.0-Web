require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"
# This class performs functions related to adding and viewing elements from the users table in the saints database.
class User
  extend DatabaseClassMethod
  include DatabaseInstanceMethod
  
  attr_accessor :id, :user_name
  # Creates an instance of the User class.
  #
  # values - hash with "id" and "user_name" values
  def initialize(values = {})
    @id = values["id"].to_i
    @user_name = values["user_name"]
  end
  
end