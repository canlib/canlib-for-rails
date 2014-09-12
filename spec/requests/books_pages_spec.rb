require 'rails_helper'
include ApplicationHelper

describe "Pages", :type => :request do

	subject {page}

	describe "Books page" do
		before {visit books_path}

		it {is_expected.to have_content('蔵書一覧')}
		it {is_expected.to have_title(full_title('蔵書一覧'))}
	end

end
