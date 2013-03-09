FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "foo#{n}@example.com" }
    password "password"
    full_name "Volodymyr Barna"
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

  factory :address do
    sequence(:line_1) { |n| "Ruska 1#{n}/3#{n}" }
    line_2 "2 floor, from backdoor"
    city "Ternopil"
    country "Ukraine"
    postcode 12345
    phone_number "+380970377658"
    user
  end

  factory :order do
    address
    pay_type "Check"
    shipping_type "Express"
  end
end
