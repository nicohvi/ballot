FactoryGirl.define do

  factory :option do
    sequence(:name) { |n| "option-#{n}" }
    poll
  end

end
