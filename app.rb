require "sqlite3"
require "sinatra"
require "sinatra/reloader"
require "pry"
require "bcrypt"

CONNECTION = SQLite3::Database.new("saints.db")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS 'countries' (id INTEGER PRIMARY KEY, country_name TEXT UNIQUE NOT NULL, country_description TEXT NOT NULL)")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS 'categories' (id INTEGER PRIMARY KEY, category_name TEXT UNIQUE NOT NULL)")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS 'saints' (id INTEGER PRIMARY KEY, saint_name TEXT NOT NULL, 
canonization_year INTEGER, description TEXT NOT NULL, category_id INTEGER, country_id INTEGER)")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS 'users' (id INTEGER PRIMARY KEY, user_name TEXT, password TEXT)")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS 'changes' (id INTEGER PRIMARY KEY, change_description TEXT, user_id INTEGER)")

CONNECTION.results_as_hash = true

#--------------------------------------------------------------------------------------------

require_relative "country.rb"
require_relative "category.rb"
require_relative "saint.rb"
require_relative "user.rb"
require_relative "change.rb"

#--------------------------------------------------------------------------------------------
enable :sessions

def check_user
  if session[:id] == nil
    redirect "/home"
  end
end  

get "/home" do
  session[:id] = nil
  erb :home
end

get "/user" do
  array = User.where("user_name", params["user_name"])
  if array == []
    @errors = "Login Failed."
    return erb :home
  end
  user = array[0]
  if user.valid_password?(params["password"])
    session[:id] = user.id
    @name = user.user_name
    binding.pry
    erb :login_success
  else
    @errors = user.errors
    erb :home
  end
end

get "/new_user_form_do" do
  password = BCrypt::Password.create(params["password"])
  user = User.new({"id" => nil, "user_name" => params["user_name"], "password" => password})
  if user.add_to_database
    session[:id] = user.id
    Change.add({"change_description" => "Added #{params["user_name"]} to users.", "user_id" => session["id"]})
    @name = user.user_name
    erb :login_success
  else
    @errors = user.errors
    params["cat"] = "user"
    erb :new_form
  end
end

#---------------------------------------------------------------------------------
get "/main_menu" do
  check_user
  erb :main_menu
end

get "/saint_countries" do
  check_user
  erb :saint_countries
end

get "/saint_categories" do
  check_user
  erb :saint_categories
end

get "/individual_saints" do
  check_user
  erb :individual_saints
end

get "/user_changes" do
  check_user
  erb :user_changes
end

get "/all/:cat" do
  check_user
  erb :all
end

get "/delete/:cat" do
  check_user
  erb :delete
end

get "/new_form/:cat" do
  check_user
  erb :new_form
end

get "/update_form/:cat" do
  check_user
  erb :update_form
end

get "/where/:cat" do
  check_user
  erb :where
end
#--------------------------------------------------------------------------------

get "/new_country_form_do" do
  check_user
  country = Country.new({"id" => nil, "country_name" => params["country_name"], "country_description" => params["description"]})
  if country.add_to_database
    Change.add({"change_description" => "Added #{params["country_name"]} to countries.", "user_id" => session["id"]})
    @message = "Country added."
    erb :saint_countries
  else
    @errors = country.errors
    params["cat"] = "country"
    erb :new_form
  end
end

get "/update_country_form_do" do
  check_user
  country = Country.find(params["country_id"])
  @message = []
  if params["name"] != ""
    country.country_name = params["name"]
    if country.valid?
      country.save
      Change.add({"change_description" => "#{params["name"]}'s name updated in countries.", "user_id" => session["id"]})
      @message << "Country name updated."
    else
      @errors = country.errors
      params["cat"] = "country"
      erb :update_form
    end
  end
  if params["description"] != ""
    country.country_description = params["description"]
    country.save
    Change.add({"change_description" => "#{country.country_name}'s description updated in countries.", "user_id" => session["id"]})
    @message << "Country description updated."
  end
  
  erb :saint_countries
end

get "/delete_country" do
  check_user
  if Saint.where("country_id", params["country_id"]) == []
    country = Country.find(params["country_id"])
    name = country.country_name
    @message = country.delete
    Change.add({"change_description" => "#{name} deleted from countries.", "user_id" => session["id"]})
    erb :saint_countries
  else
    @message = "The country has saints associated with it, it cannot be deleted."
    erb :saint_counries
  end
end

#-------------------------------------------------------------------------------------

get "/new_category_form_do" do
  check_user
  category = Category.new({"id" => nil, "category_name" => params["category_name"]})
  if category.add_to_database
    Change.add({"change_description" => "Added #{params["category_name"]} to categories.", "user_id" => session["id"]})
    @message = "Category added."
    erb :saint_categories
  else
    @errors = category.errors
    params["cat"] = "category"
    erb :new_form
  end
end

get "/delete_category" do
  check_user
  if Saint.where("category_id", params["category_id"]) == []
    category = Category.find(params["category_id"])
    name = category.category_name
    @message = category.delete
    Change.add({"change_description" => "#{name} deleted from categories.", "user_id" => session["id"]})
    erb :saint_categories
  else
    @message = "The category has saints associated with it, it cannot be deleted."
    erb :saint_categories
  end
end

#-----------------------------------------------------------------------------------

get "/new_saint_form_do" do
  check_user
  Saint.add({"saint_name" => params["saint_name"], "canonization_year" => params["canonization_year"].to_i, "description" => params["description"], "category_id" => params["category_id"], "country_id" => params["country_id"]})
  @message = "Saint added."
  erb :individual_saints
end

get "/update_saint_form_do" do
  check_user
  saint = Saint.find(params["saint_id"])
  @message = []
  if params["country_id"] != "blank"
    saint.country_id = params["country_id"]
    saint.save
    Change.add({"change_description" => "#{saint.saint_name}'s country updated in saints.", "user_id" => session["id"]})
    @message << "Saint country updated."
  end
  if params["category_id"] != "blank"
    saint.category_id = params["category_id"]
    saint.save
    Change.add({"change_description" => "#{saint.saint_name}'s category updated in saints.", "user_id" => session["id"]})
    @message << "Saint category updated."
  end
  if params["name"] != ""
    saint.saint_name = params["name"]
    saint.save
    Change.add({"change_description" => "#{params["name"]}'s name updated in saints.", "user_id" => session["id"]})
    @message << "Saint name updated."
  end
  if params["canonization_year"] != ""
    saint.canonization_year = params["canonization_year"]
    saint.save
    Change.add({"change_description" => "#{saint.saint_name}'s canonization year updated in saints.", "user_id" => session["id"]})
    @message << "Saint canonization year updated."
  end
  if params["description"] != ""
    saint.description = params["description"]
    saint.save
    Change.add({"change_description" => "#{saint.saint_name}'s description updated in countries.", "user_id" => session["id"]})
    @message << "Saint description updated."
  end
  
  erb :individual_saints
end

get "/see_saint" do
  check_user
  @saint = Saint.find(params["saint_id"])
  erb :see_saint
end

get "/where_keyword_form" do
  check_user
  erb :where_keyword_form
end

get "/where_keyword_form_do" do
  check_user
  @list = []
  saint_array = Saint.where_keyword(params["keyword"])
  if saint_array == []
    @list << "No saints with that keyword in their description."
  else
    saint_array.each do |saint|
      @list << saint.saint_name
    end
  end
  
  erb :where_keyword
end

get "/delete_saint" do
  check_user
  saint = Saint.find(params["saint_id"])
  name = saint.saint_name
  @message = saint.delete
  Change.add({"change_description" => "#{name} deleted from saints.", "user_id" => session["id"]})
  erb :individual_saints
end

