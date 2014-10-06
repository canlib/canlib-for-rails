require 'rails_helper'

describe LendingsController do
	before do
		@book_lending = Book.create(:title => "lending book", :author_name => "example author")
		@book_lending2 = Book.create(:title => "lending book2", :author_name => "example author")
		@book_no_lending = Book.create(:title => "No lending book", :author_name => "example author")
		@book_no_lending2 = Book.create(:title => "No lending book2", :author_name => "example author")
	
		@lending = Lending.create(:book_id => @book_lending.id, :date => Date.today, :period => 14, :user_name => "a")
		@lending2 = Lending.create(:book_id => @book_lending2.id, :date => Date.today, :period => 14, :user_name => "a")
	end

	describe "#index" do
		before {get :index}
		
		it "should be success" do
			expect(response.status).to eq(200) 
			expect(response).to render_template("index")
		end

		describe "when job is lending" do
			before {get :index, :job => "lending"}

			it "should be success" do
				expect(response.status).to eq(200)
				expect(response).to render_template("index")
			end

			it "should have all lending books" do
				expect(assigns[:books].size).to eq(Book.includes(:lending).where(:lendings => {:book_id => nil}).count)
			end
		end

		describe "when job is return" do
			before {get :index, :job => "return"}

			it "should be success" do
				expect(response.status).to eq(200)
				expect(response).to render_template("index")
			end

			it "should have all lending books" do
				expect(assigns[:books].size).to eq(Book.joins(:lending).count)
			end
		end
	end

	describe "#new" do
		before {get :new, :book_id => @book_lending.id}
		
		it "should be success" do
			expect(response.status).to eq(200)
			expect(response).to render_template("new")
		end
	end

	describe "#create" do
		let(:request) {post :create, params}

		describe "with the valid data" do
			let(:params) {{:lending => {:date => Date.today, :period => 14, :user_name => "test"}, :book_id => @book_no_lending.id}}

			it "should be success" do
				request
				expect(response.status).to eq(302)
				expect(response).to redirect_to lendings_path(:job => "lending")
			end

			it "should create new lending" do
				expect {post :create, params}.to change(Lending, :count).by(1)
			end
		end

		describe "with the invalid data" do
			let(:params) {{:lending => {:user_name => "\s"}, :book_id => @book_no_lending.id}}

			it "should be validation error" do
				request
				expect(assigns(:lending).errors).not_to be_empty
			end

			it "should not create new lending" do
				expect {request}.not_to change(Lending, :count)
			end
		end

		describe "when the lending already exists" do
			let(:params) {{:lending => {:user_name => "test"}, :book_id => @book_lending.id}}
			
			it "should not create new lending" do
				expect {request}.not_to change(Lending, :count)
			end
		end
	end

	describe "#destroy" do
		let(:request) {delete :destroy, :book_id => @book_lending.id, :id => @lending.id}

		describe "when the lending is empty" do
			before {@lending.destroy}

			it "should be error" do
				expect {request}.not_to change(Lending, :count)
			end
		end

		describe "when the lending exists" do
			it "should be success" do
				request
				expect(assigns(:lending).errors).to be_empty
			end

			it "should destroy one lending" do
				expect {request}.to change(Lending, :count).by(-1)
			end
		end		
	end

	describe "#search" do
		let(:request) {get :search, params}

		describe "when job is lending" do
			let(:params) {{:search_string => "2", :job => "lending"}}

			it "should be success" do
				request
				expect(response.status).to eq(200)
			end

			it "should read index template" do
				request
				expect(response).to render_template("index")
			end

			it "should have matching books" do
				request
				expect(assigns[:books].size).to eq(Book.includes(:lending).where(:lendings => {:book_id => nil}).where("title like '%2%'").count)
			end
		end

		describe "when job is return" do
			let(:params) {{:search_string => "2", :job => "return"}}

			it "should be success" do
				request
				expect(response.status).to eq(200)
			end

			it "should read index template" do
				request
				expect(response).to render_template("index")
			end

			it "should have matching books" do
				request
				expect(assigns[:books].size).to eq(Book.joins(:lending).where("title like '%2%'").count)
			end
		end
	end
end
