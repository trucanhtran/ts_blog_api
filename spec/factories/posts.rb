FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post Title #{n}" }
    sequence(:content) { |n| "Post content #{n}" }
    published { false }
    association :author, factory: :user
  end
end
