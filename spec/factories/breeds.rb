FactoryGirl.define do
  factory :breed do
    name { FFaker::Name.name }

    trait :with_tag do
      transient { tag_count 0 }

      after(:create) do |breed, evaluator|
        FactoryGirl.create_list(:breed_tag_record, evaluator.tag_count, breed: breed)
      end
    end
  end
end
