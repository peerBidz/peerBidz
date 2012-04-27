# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :searchdb do
    buyeripaddress "MyString"
    searchquery "MyString"
    category "MyString"
  end
end
