FactoryGirl.define do
  factory :topic do
    sequence(:name) { |n| "Topic #{n}" }
    sequence(:description) { |n| "Description #{n}" }

    trait :with_instructionals do
      after(:create) do |topic|
        create :instructional, topic: topic
        create :instructional, url: "http://youtu.be/kffacxfA7G4", topic: topic
      end
    end
  end
end
