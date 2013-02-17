# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    full_name "MyString"
    line_1 "MyString"
    line_2 "MyString"
    city "MyString"
    country "MyString"
    postcode 1
    phone_number "MyString"
    belongs_to ""
  end
end
