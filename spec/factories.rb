FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "foo#{n}@example.com" }
    password "password"
    first_name "qwerty"
    last_name "lolovich"
    admin false

    factory :admin do
      admin true
    end
  end

  factory :category do
    sequence(:name) { |n| "Category#{n}" }
  end

  factory :product do
    sequence(:title) { |n| "Intel Core i5-375#{n}k BOX" }
    description "OMGWTFBBQ"
    image_url 'ruby.jpg'
    category
    price 25.39
  end

end
