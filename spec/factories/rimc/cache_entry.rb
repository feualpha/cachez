FactoryBot.define do
  factory :cache_entry, class: Rimc::CacheEntry do
    cached_object = Object.new

    trait :forever do
      expire_time nil
    end
  end
end