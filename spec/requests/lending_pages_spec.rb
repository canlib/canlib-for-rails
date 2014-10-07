require 'rails_helper'

describe "Lending pages", :type => :request do

	subject {page}

	describe "create" do
		before do
      @book = Book.create(title: "Example Book", author_name: "Example Author")
      visit new_book_lending_path(@book)
		end
		let(:submit) {"Create Lending"}

		describe "with invalid information" do
			it "should not create a lending" do
				expect {click_button submit}.not_to change(Lending, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Date", with: Date.today
				fill_in "Period", with: 10
				fill_in "User name", with: "Example User"
			end

			it "should create a lending" do
				expect {click_button submit}.to change(Lending, :count).by(1)
			end
		end

		describe "with same book id" do
			before do
				@lending = Lending.create(date: Date.today, period: 14, user_name: "Example User", book_id: @book.id)
				fill_in "Date", with: Date.today
				fill_in "Period", with: 10
				fill_in "User name", with: "Example User2"
			end

			it "should not create a lending" do
				expect {click_button submit}.not_to change(Lending, :count)
				expect(Lending.find(@lending.id).user_name).to eq("Example User")
			end
		end
	end

	describe "destroy" do
		before do 
			book2 = FactoryGirl.create(:book)
			@lending2 = FactoryGirl.create(:lending, book: book2)
		end

		describe "as correct book" do
			before do
				visit '/lendings?jo=return'
			end

			it "should delete a lending" do
				expect {Lending.find_by(id: @lending2.id).destroy}.to change(Lending, :count).by(-1)
			end
		end

		describe "when the lending already deleted" do
			before {Lending.find_by(id: @lending2.id).destroy}

			subject {page}
			it {is_expected.not_to have_link("Return")}
		end
	end

end
