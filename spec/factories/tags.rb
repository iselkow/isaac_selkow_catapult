FactoryGirl.define do
  factory :tag do
    name { FFaker::Music.artist } # why not?

    trait :with_breed do
      transient { breed_count 0 }

      after(:create) do |tag, evaluator|
        FactoryGirl.create_list(:breed_tag_record, evaluator.breed_count, tag: tag)
      end
    end
  end
end
