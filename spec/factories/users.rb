FactoryGirl.define do

  factory :user, aliases: [:owner] do
    sequence(:name)  { |n| "Frank the #{n}th, or whatever" }
    sequence(:email) { |n| "frank-#{n}@email.com" } 
    sequence(:password) { |n| "password-#{n}" }
  end

end
