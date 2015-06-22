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
    
    return @errors.empty?
  end
  
end