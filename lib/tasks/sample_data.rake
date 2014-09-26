namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		Book.create!(title: "書籍サンプル", author_name: "著者サンプル")
		99.times do |n|
			title = Faker::Name.title
			author_name = Faker::Name.name
			Book.create!(title: title, author_name: author_name)
		end
		30.times do |n|
			id = Random.rand(100) + 1
			Lending.create(date: Date.today, period: 14, user_name: Faker::Name.name, book_id: id)
		end
	end
end
