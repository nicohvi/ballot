require 'factory_girl'
require 'byebug'
include FactoryGirl::Syntax::Methods
Dir.glob("spec/factories/*.rb").map { |file| 
  require File.expand_path file 
}

# Cleanup
User.delete_all
Poll.delete_all

10.times do
  create :user
end

50.times do 
  create :poll, owner: User.first
end

user = User.first
user.email = 'nico.hvi@gmail.com'
user.save!
