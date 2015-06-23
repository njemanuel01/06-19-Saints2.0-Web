#Saint Manager

I created a program that creates a SQL database with five tables: users, changes, countries, categories, and saints.  Each of those tables is accessible through a class:  User, Change, Country, Category, and Saint.  The program also allows the user to add, make changes to, and delete entries from those tables using the corresponding classes.  Each country has a unique ID and it's name and description taken.  Each category has a unique ID and a name.  Each saint has it's own unique ID, a name, a canonization year, and a description,  as well as an id for the country it belongs to and another for the category it belongs to.

##app.rb

The driver for the program is located in the app.rb file.  This file uses gets methods and .erb files to create a web interface for the saint manager program.  Users can see records in the different databases, make additions, make changes to existing records, and delete entries as well.  For example, this gets method in the app.rb allows the user to add a country to the countries database (it also tests to make sure the country doesn't already exist).

```ruby
get "/new_country_form_do" do
  country = Country.new({"id" => nil, "country_name" => params["country_name"], "country_description" => params["description"]})
  if country.add_to_database
    Change.add({"change_description" => "Added #{params["country_name"]} to countries.", "user_id" => $id})
    @message = "Country added."
    erb :saint_countries
  else
    @errors = country.errors
    params["cat"] = "country"
    erb :new_form
  end
end
```

The corresponding .erb file looks like this.

```ruby
<h1>Please enter all the information below and hit submit.</h1>

<form action="/new_country_form_do">
  <input type="text" placeholder="New Country Name" name="country_name" value="<%= params["country_name"] %>">
  <input type="text" placeholder= "New Country Description" name="description">
  <input type="submit">
</form>

<a href="/saint_countries">Return to Saint Countries</a></b>
<a href="/main_menu">Return to Main Menu</a></b>
```

##user.rb

The User class creates an instance for each user with his/her own unique ID.  It also checks to see if passwords are valid and whether they match the when the user logs in.  It can also create a new user:

```ruby
def self.add(user_name)
  CONNECTION.execute("INSERT INTO users (user_name) VALUES (?);", user_name)
  "#{user_name} added."
end
```

and creates a new record in the changes table whenever an addition, update, or deletion occurs.  It returns a string to say the the change was recorded.

```ruby
def add_change(description)
  CONNECTION.execute("INSERT INTO changes (change_description, user_id) VALUES (?, ?);", description, @u_id)
  "Change recorded."
end
```

##change.rb

The Change class allows the user to access a list of changes that have been made to the database as well as a list of changes that only the current user has made to the database.  The method returns an Array of Hashes with information on the changes the current user has made.

```ruby
def self.where_user(user_id)
  CONNECTION.execute("SELECT * FROM 'changes' WHERE user_id = ?;", user_id)
end
```

##country.rb
The Country class allows the user to add a country to the database, see a list of countries, as well as information on a specific country.  Upon creating an instance of Country, the user can update information on any countries in the database:

```ruby
def update_names(name)
  CONNECTION.execute("UPDATE 'countries' SET country_name = ? WHERE id = ?;", name, @l_id)
  "Name updated."
end
  
def update_descriptions(description)
  CONNECTION.execute("UPDATE 'countries' SET country_description = ? WHERE id = ?;", description, @l_id)
  "Description updated."
end
```

both of these return a string letting the user know that the changes have been made.  The user can also delete a country from the database.

##category.rb

The Category class allows the user to create a new category as well as see a full list of categories in the database.  Upon creating an instance of the class, the user can delete a category from the database.  A string is returned letting the user know that the deletion has occurred.

```ruby
def delete
  CONNECTION.execute("DELETE FROM 'categories' WHERE id = ?;", @c_id)
  "Category Deleted"
end
```

##saint.rb

The Saint class allows the user to see a full list of saints in the database as well as seeing a list of saints given a particular country ID or category ID.  These methods return an Array of Hashes with the saints for each.

```ruby
def self.where_country(country_id)
  CONNECTION.execute("SELECT saint_name FROM 'saints' WHERE country_id = ?;", country_id)
end
```

```ruby
def self.where_category(category_id)
  CONNECTION.execute("SELECT saint_name FROM 'saints' WHERE category_id = ?;", category_id)
end
```

The user can also search for a list of saints by giving a keyword in the saint's description.  This method returns an Array with the saints that match the keyword.

```ruby
def self.where_keyword(keyword)
  saint_array = []
  array = self.all
  array.each do |x|
    string_array = x["description"].split
    if (string_array.include?(keyword) || string_array.include?(keyword.capitalize))
      saint_array.push("#{x["id"]}-#{x["saint_name"]}")
    end
  end
  if saint_array == []
    "No saints with that keyword in their description."
  else
    saint_array
  end
end
```

The Saint class also allows the user to make changes to and delete entries from the saints table in a similar fashion as the other classes.