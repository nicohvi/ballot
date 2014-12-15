FactoryGirl.define do 

  factory :poll do
    sequence(:name) { |n| "Election number #{n}" }

    trait :guest do
      owner nil
      guest_token SecureRandom.uuid
    end

    trait :restricted do
      allow_anonymous false
    end
    
    trait :closed do
      closed true
    end
 
    after(:create) do |poll|
      create_list :option, 3, poll: poll
    end
    
    factory :closed_poll, traits: [:closed]
    factory :guest_poll, traits:  [:guest]
    factory :closed_guest_poll, traits: [:closed, :guest]
    factory :restricted_poll, traits: [:restricted]
  end
end
