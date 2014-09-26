require 'rails_helper'

describe "Lending pages" do
	subject {page}

	describe "index" do
		before do
			FactoryGirl.create(:book)
			book2 = FactoryGirl.create(:book)
			FactoryGirl.create(:lending, book: book2)
			visit lendings_path
		end

		it {should have_title('貸出状況一覧')}
		it {should have_content('貸出状況一覧')}

		describe "pagination" do
			before(:all) do
				30.times{FactoryGirl.create(:book)}
				Book.all.each do |book|
					FactoryGirl.create(:lending, book: book)
				end
			end
			after(:all) {Book.delete_all}
	
			it {should have_selector('div.pagination')}
		end			
	end

end
