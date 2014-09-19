FactoryGirl.define do
	factory :book do
		title "Example Book"
		author_name "Example Author"
	end

	factory :lending do
		date Date.today
		period 14
		user_name "Example User"
		book
	end
end
