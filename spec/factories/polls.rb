FactoryGirl.define do 

  factory :poll do
    sequence(:name) { |n| "Election number #{n}" }
  end

end
