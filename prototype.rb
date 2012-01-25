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
  choice = input("Which record would you like to edit? (type the ID number)")

  
  # if they type in something retarded instead of a number, to_i returns 0.
  if choice.to_i == 0
    puts "You didn't type a number, dummy."
    
  else
    #if the integer they enter doesn't correspond to an existing ID'
    if db.execute("Select ids, firstname, lastname, phone, address, 
                    email FROM contacts WHERE ids = #{choice}").empty?       
      puts "Sorry, the ID you selected is not valid.  Goodbye."
      
    else
      #things check out -- go ahead and edit the contact
      edit_contact(db, choice) 
      
    end
  end  
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

  #db.execute(query) if db.complete? query
end





# INSIDE A CONTACT RECORD
# these functions should only be called from the "contact display" screen, 
# and called on a specific contact record

def edit_contact(db, contact_id)
  # Get the right record, stuff the data into the "contact" variable
  edit_contact_query = "SELECT 
      ids
      ,firstname
      ,lastname
      ,phone
      ,address
      ,email
      ,occupation
      ,company
      ,tags
      
  FROM contacts WHERE ids = #{contact_id};"
  
  contact = db.execute(edit_contact_query)

  # edit the data
  puts "The contact record you've chosen is:\n\n#{contact}\n\n"
  what_to_change = input("What would you like to change?  You can change
  
          firstname
          lastname
          phone
          address
          email
          occupation
          company
          
          or you can type 'edit tags' to edit associated tags.")
          
  if what_to_change == "edit tags"
    #WARNING -- passes the whole contact array into the edit-tags function
    edit_tags(contact)
    
  #if it's an allowed choice  
  elsif [ "firstname", "lastname", "phone", "address", "email", "occupation", "company",].include?(what_to_change)
    newinfo = input("What would you like to change the #{what_to_change} to?")
    
    #make the change
    query = "UPDATE contacts
              SET #{what_to_change}='#{newinfo}'
              WHERE ids='#{contact_id}'"
              
    db.execute(query)
    
  end
    
    changedcontact = db.execute(edit_contact_query)
    puts "The contact record is now\n\n#{changedcontact}\n\n"
    
end





def edit_tags(contact)
  #TODO: add REMOVE TAGS feature
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
  :edit => Proc.new {edit_contact(db,"1")},
  
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