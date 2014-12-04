FactoryGirl.define do 

  factory :poll do
    sequence(:name) { |n| "Election number #{n}" }
  
    factory :poll_with_options do

      transient do
        options_count 5
      end

      after(:create) do |poll, evaluator|
         create_list :option, evaluator.options_count, poll: poll  
      end
    end    
  end
end
