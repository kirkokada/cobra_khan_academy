FactoryGirl.define do
  factory :topic do
    sequence(:name) { |n| "Topic #{n}" }
    sequence(:description) { |n| "Description #{n}"}
    parent_id nil
  end
end
