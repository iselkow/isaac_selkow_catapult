FactoryGirl.define do
  factory :tag do
    name { FFaker::Music.artist } # why not?
  end
end
