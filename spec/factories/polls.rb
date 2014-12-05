FactoryGirl.define do 

  factory :poll do
    sequence(:name) { |n| "Election number #{n}" }

    trait :guest do
      owner nil
      guest_token SecureRandom.uuid
    end
    
    trait :closed do
      closed true
    end
 
    factory :poll_with_options do
      transient do
        options_count 5
      end
    
      after(:create) do |poll, evaluator|
        create_list :option, evaluator.options_count, poll: poll
      end
    end

    factory :closed_poll, traits: [:closed]
    factory :guest_poll, traits:  [:guest]
    factory :closed_guest_poll, traits: [:closed, :guest]
  end
end
