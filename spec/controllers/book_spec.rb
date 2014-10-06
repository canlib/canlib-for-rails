require 'rails_helper'

describe BooksController, :type => :controller do

	before do
		@book = FactoryGirl.create(:book)
		@params = {
			:title => @book.title,
			:author_name => @book.author_name
		}
	end

	describe "#create" do
		describe "when successful" do
			it "should create new book" do
				expect {
				 post :create, :book => @params 
				}.to change(Book, :count).by(1)
			end

			it "should redirect to book page" do
				post :create, :book => @params
				expect(response).to redirect_to books_path
			end
		end

		describe "when error" do
			describe "with empty title" do
				before do
					@params_no_title = {
						title: "\s",
						author_name: "test"
					}
				end

				it "should not create new book" do
					expect {post :create, :book => @params_no_title}.to_not change(Book, :count)
				end

				it "should redirect to books page" do
					post :create, :book => @params_no_title
					expect(response).to redirect_to books_path
				end
			end
			
			describe "with empty author name" do
				before do
					@params_no_authorname = {
						title: "test",
						author_name: "\s"
					}
				end

				it "should not create new book" do
					expect {post :create, :book => @params_no_authorname}.to_not change(Book, :count)
				end

				it "should redirect to books page" do
					post :create, :book => @params_no_authorname
					expect(response).to redirect_to books_path
				end
			end
		end
	end

	describe "#index" do
		before {get :index}

		it "should be success" do
			expect(response.status).to eq(200)
		end

		it "should read index template" do
			expect(response).to render_template("index")
		end

		it "should have all books" do
			expect(assigns[:books].size).to eq(Book.all.count)
		end
	end

	describe "#update" do
		describe "with the valid data" do
			before do
				patch :update, :book => @params, :id => @book.id					
			end
			
			it "should not accord with the selected book" do
				expect(assigns(:book)).to eq(@book)
			end

			it "should redirect to edit book page" do
				expect(response).to redirect_to edit_book_path(@book.id)
			end
			
			it "should not be error" do
				request
				expect(assigns(:book).errors).to be_empty
			end
		end
	
		describe "with the invalid data" do
			before do
				@invalid_params = {
					:title => "\s",
					:author_name => @book.author_name
				}
				patch :update, :book => @invalid_params, :id => @book.id
			end
			
			it "should not accord with the selected book" do
				expect(assigns(:book)).to eq(@book)
			end

			it "should redirect to edit book page" do
				expect(response).to redirect_to edit_book_path(@book.id)
			end

			it "should be validation error" do
				expect(assigns(:book).errors).not_to be_empty
			end
		end
	end

	describe "#destroy" do
		describe "with the right data" do
			let(:request) {delete :destroy, params}
			let(:params) {{:id => @book.id}}
			
			it "should redirect to books page" do
				request
				expect(response).to redirect_to books_path
			end

			it "should delete one book" do
				expect{delete :destroy, :id => @book.id}.to change(Book, :count).by(-1)
			end

			it "should accord with the selected book" do
				request
				expect(assigns(:book)).to eq(@book)
			end
		end
	end

	describe "#search" do
		before do
			@book2 = Book.create(:title => "a", :author_name => "a")
			get :search, :search_string => "example"
		end

		it "should be success" do
			expect(response).to be_success
		end

		it "should read index template" do
			expect(response).to render_template("index")
		end

		it "should have matching books" do
			expect(assigns[:books].size).not_to eq(Book.all.count)
			expect(assigns[:books].size).to eq(1)
		end
	end

end
