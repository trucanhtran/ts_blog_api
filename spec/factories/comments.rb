FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "Comment content #{n}" }
    association :post
    association :author, factory: :user
  end
end
