require 'rails_helper'
include ApplicationHelper

describe "Pages", :type => :request do

	subject {page}

	describe "Books page" do
		before {visit root_path}

		it {is_expected.to have_content(I18n.t('books.title.index'))}
		it {is_expected.to have_title(full_title(I18n.t('books.title.index')))}

		describe "pagination" do
			before(:all) do
				100.times{FactoryGirl.create(:book)}
			end
			after(:all) {Book.delete_all}
	
			it {is_expected.to have_selector('div.pagination')}
		end			
	end

end
