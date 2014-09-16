require 'rails_helper'

describe Book do

	before {@book = Book.new(title: "Example Book", author_name: "Example Author")}

	subject {@book}

	it {should respond_to(:title)}
	it {should respond_to(:author_name)}

	it {should be_valid}

	describe "when title is not present" do
		before {@book.title = "\s"}
		it {should_not be_valid}
	end

	describe "when author_name is not present" do
		before {@book.author_name = "\s"}
		it {should_not be_valid}
	end

	describe "when title is too long" do 
		before {@book.title = "a" * 51}
		it {should_not be_valid}
	end

	describe "when author_name is too long" do
		before {@book.author_name = "a" * 31}
		it {should_not be_valid}
	end

end
