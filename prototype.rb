eval File.read('daveutils.rb')
require "sqlite3"

#Constants
Database_Path = 'contacts.db'

# load database if it exists, otherwise create and initialize new DB
if File.exist?(Database_Path)
  puts "DEBUG! the file already exists! about to open file"
  db = SQLite3::Database.open(Database_Path)
else
  db = SQLite3::Database.new(Database_Path)
  query = "CREATE TABLE contacts(
      ids INTEGER PRIMARY KEY,
      firstname VARCHAR(255),
      lastname VARCHAR(255),
      phone VARCHAR(255),
      address VARCHAR(255),
      email VARCHAR(255),
      occupation VARCHAR(255),
      company VARCHAR(255),
      tags VARCHAR(255)
       );"
   if db.complete? query
     puts "Query is good...Executing the query!"
     db.execute(query)
   else
     puts "Your query is not correct."
   end
   
end



def view_contacts(db)
  
  #show decoration: (title bar)
  puts "ID  First   Last   Phone   Address    e-mail   Occupation   Company    Tags"
  #get a list of all contacts in the database
  db.execute("SELECT * FROM contacts") {|row|
    #display that list, with indexes
    puts "#{row[0]}  | #{row[1]} | #{row[2]} | #{row[3]} | #{row[4]} | #{row[5]} | #{row[6]} | #{row[7]} | #{row[8]} "
  }
  #let the user choose which record to view (or to go back to the main menu)
  
end


def search
  #get input for type of search (by tag, by name, by address)
  
  
  # search records by the chosen input fields
  
end


def new_contact(db)
  # get all the fields for the record
  fname = input("What's the first name for the new contact?")
  lname = input("What's the last name?")
  phone = input("What's their phone number?")
  address = input("What's their address?")
  email = input("What's their e-mail address?")
  occupation = input("What's their occupation?")
  company = input("What company do they work for?")
  tags = input("What tags do you want to associate with this person?  Separate tags with commas.")
  
  # commit record to database
  query = %Q{INSERT INTO "contacts" VALUES
  (NULL,
  '#{fname}',
  '#{lname}',
  '#{phone}',
  '#{address}',
  '#{email}',
  '#{occupation}',
  '#{company}',
  '#{tags}'
  );}
  
  puts "DEBUG: the query is #{query}"
  db.execute(query) if db.complete? query
  
  
end



# INSIDE A CONTACT RECORD
# these functions should only be called from the "contact display" screen, 
# and called on a specific contact record

def edit_contact
  # used in CREATING NEW RECORDS and for EDITING EXISTING CONTACTS
  # edit info
  
  # commit record to database
  
end

def add_tag_to_contact(contact)
  # get the tags that should be added
  
  # add those tags to the contact record
end



# this is probably an overly complicated solution
# spaghetti code!!!
Choices = {
  :view => Proc.new {view_contacts(db)},
  :search => Proc.new {"ha"},
  :new => Proc.new {new_contact(db)},
  :quit => Proc.new {"schna"},
  
  # choices from "view"
  :choose_contact => Proc.new {"choose_contact"},
  
}


# Show main menu
def choose_at_main_menu
  choice = input("Welcome to Dave's contact manager.  Choose from the options below:
  
  view    - view all contacts
  search  - search for a specific contact
  new     - create a new contact
  quit    - exit the contact manager
  
  Just type your choice and hit ENTER to select.")

  chosen = choice.to_sym
  #execute the proc for that choice
  Choices[chosen].call
  
end









###############
## Main
###############

choose_at_main_menu()



# finally, close the database
db.close