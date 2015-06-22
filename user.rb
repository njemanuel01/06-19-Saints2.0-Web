require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"
# This class performs functions related to adding and viewing elements from the users table in the saints database.
class User
  extend DatabaseClassMethod
  include DatabaseInstanceMethod
  
  attr_accessor :id, :user_name, :errors
  # Creates an instance of the User class.
  #
  # values - hash with "id" and "user_name" values
  def initialize(values = {})
    @id = values["id"].to_i
    @user_name = values["user_name"]
    @password = values["password"]
    @errors = []
  end
  
  # Checks to see if a user name already exists in the table
  #
  # Returns a Boolean.
  def valid?
    array = self.class.all
    array.each do |user|
      if @user_name == user.user_name
        @errors << "This username already exists."
      end
    end
    
    if @password == ""
      @errors << "No password entered."
    end
    
    return @errors.empty?
  end
  
  # Checks to see if the user has entered the correct password
  #
  # Returns a Boolean.
  def valid_password?(password)
    if @password != password
      @errors << "Invalid password."
    end
    
    return @errors.empty?
  end
  
end