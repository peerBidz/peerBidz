# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shippinginfo do
    itemid 1
    name "MyString"
    street "MyString"
    city "MyString"
    state "MyString"
    zip "MyString"
  end
end
