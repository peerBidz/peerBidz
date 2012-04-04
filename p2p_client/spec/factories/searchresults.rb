# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :searchresults do
    search_string "MyString"
    category "MyString"
    ipaddress "MyString"
  end
end
