Before do
	book1 = Book.create(title: "Test Book", author_name: "Test Author")
	book2 = Book.create(title: "Test Book2", author_name: "Test Author")
	Lending.create(book_id: book2.id, user_name: "Test User", date: Date.today, period: 14)
end

Before '@paginate' do
	50.times do
		Book.create(title: "Paginate Test", author_name: "ptest")
	end
end

After '@paginate' do
	50.times do
		Book.find_by(title: "Paginate Test").destroy
	end
end
