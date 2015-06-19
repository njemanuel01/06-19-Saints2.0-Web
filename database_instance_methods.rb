require "active_support"
require "active_support/inflector"

#Creates instance methods to access the database with.
module DatabaseInstanceMethod
  
  # Gets a single column value from a row in a table
  #
  # Retuns either a string or integer
  def get(field)
    table_name = self.class.to_s.pluralize.underscore
    
    result = CONNECTION.execute("SELECT * FROM '#{table_name}' WHERE id = ?;", @id).first
    result[field]
  end
  
  # Updates the information in a single row of a table
  #
  # Returns a string.
  def save
    table_name = self.class.to_s.pluralize.underscore
    
    hash = {}
    self.instance_variables.each {|var| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
    hash.delete("id")
    hash.delete("errors")
    sql_hash = hash.to_s.delete "\>"

    CONNECTION.execute("UPDATE '#{table_name}' SET #{sql_hash[1...-1]} WHERE id = ?;", @id)
    "Saved."
  end
  
  # Deletes a row from a table
  #
  # Returns a string.
  def delete
    table_name = self.class.to_s.pluralize.underscore
    
    CONNECTION.execute("DELETE FROM '#{table_name}' WHERE id = ?;", @id)
    "Deleted."
  end
  
end