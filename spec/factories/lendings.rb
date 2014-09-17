# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lending do
    book_id 1
    date "2014-09-17"
    period 1
    user_name "MyString"
  end
end
