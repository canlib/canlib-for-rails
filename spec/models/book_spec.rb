require 'rails_helper'

describe Book, :type => :model do

	before {@book = Book.new(title: "Example Book", author_name: "Example Author")}

	subject {@book}

	it {is_expected.to respond_to(:title)}
	it {is_expected.to respond_to(:author_name)}
	it {is_expected.to respond_to(:lending)}

	it {is_expected.to be_valid}

	describe "when title is not present" do
		before {@book.title = "\s"}
		it {is_expected.not_to be_valid}
	end

	describe "when author_name is not present" do
		before {@book.author_name = "\s"}
		it {is_expected.not_to be_valid}
	end

	describe "when title is too long" do 
		before {@book.title = "a" * 51}
		it {is_expected.not_to be_valid}
	end

	describe "when author_name is too long" do
		before {@book.author_name = "a" * 31}
		it {is_expected.not_to be_valid}
	end

	describe "lending associations" do
		before do
			@book.save
			Lending.create(book_id: @book.id, period: 14, user_name: "a")
		end
	
		it "should destroy associated lendings" do
			expect {@book.destroy}.to change(Lending, :count).by(-1)
		end
	end

end
