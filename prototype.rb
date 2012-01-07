eval File.read('daveutils.rb')

def view_contacts
  #get a list of all contacts in the database
  
  #display that list, with indexes
  
  #let the user choose which record to view (or to go back to the main menu)
  
end


def search
  #get input for type of search (by tag, by name, by address)
  
  
  # search records by the chosen input fields
  
end


def new
  # get all the fields for the record
  
  #commit record to database
  
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
  :view => Proc.new {view_contacts},
  :search => Proc.new {"ha"},
  :new => Proc.new {"na"},
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
