require 'rails_helper'

RSpec.describe Lending, :type => :model do

	let(:book) {FactoryGirl.create(:book)}
	before do
		@lending = book.build_lending(date: Date.today, period: 7, user_name: "Example User")
	end

	subject {@lending}
	
	it {is_expected.to respond_to(:id)}
	it {is_expected.to respond_to(:book_id)}
	it {is_expected.to respond_to(:date)}
	it {is_expected.to respond_to(:period)}
	it {is_expected.to respond_to(:user_name)}

	it {is_expected.to be_valid}

	describe "when book_id is not present" do
		before {@lending.book_id = nil}
		it {is_expected.not_to be_valid}
	end

	describe "is only one" do
		it "should have only one lending" do
			expect {book.build_lending(date: Date.yesterday, period: 14, user_name: "Test")}.not_to change(Lending, :count)
		end
	end

	describe "is not present" do
		before {@lending.destroy}
		
		subject {book}
		it {is_expected.to be_valid}
	end

end
