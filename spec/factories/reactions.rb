FactoryBot.define do
  factory :reaction do
    kind { %w[like love laugh angry sad wow].sample }
    association :user
    association :reactionable, factory: :post
  end
end
