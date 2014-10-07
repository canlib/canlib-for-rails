require 'rails_helper'

describe BooksController, :type => :controller do

	before do
		@book = FactoryGirl.create(:book)
		@book2 = FactoryGirl.create(:book)
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
					expect(response.status).to eq(302)
					expect(response).to redirect_to books_path
				end
			end
		end
	end

	describe "#index" do
		before {get :index}

		it "should be success" do
			expect(response.status).to eq(200)
			expect(response).to render_template("index")
			expect(assigns[:books].size).to eq(Book.all.count)
		end
	end

	describe "#update" do
		describe "with unknown parameters" do
			let(:request) {patch :update, :book => {:title => "new title", :author_name => "new author", :admin => true}, :id => @book.id}

			it "should be success" do
				request
				expect(assigns[:book].title).to eq("new title")
				expect(response.status).to eq(302)
				expect(response).to redirect_to edit_book_path
			end
		end

		describe "with the valid data" do
			before do
				patch :update, :book => @params, :id => @book.id					
			end
			
			it "should be success" do
				expect(assigns(:book)).to eq(@book)
				request
				expect(assigns(:book).errors).to be_empty
				expect(response.status).to eq(302)
				expect(response).to redirect_to edit_book_path(@book.id)
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
			
			it "should be error" do
				expect(assigns(:book)).to eq(@book)
				expect(assigns(:book).errors).not_to be_empty
				expect(response.status).to eq(302)
				expect(response).to redirect_to edit_book_path(@book.id)
			end
		end
	end

	describe "#destroy" do
		describe "with the valid data" do
			let(:request) {delete :destroy, params}
			let(:params) {{:id => @book.id}}
			
			it "should delete one book" do
				expect{request}.to change(Book, :count).by(-1)
				expect(assigns(:book)).to eq(@book)
				expect(response.status).to eq(302)
				expect(response).to redirect_to books_path
			end
		end
	end

	describe "#search" do
		before do
			@book2 = Book.create(:title => "a", :author_name => "a")
			get :search, :search_string => "example"
		end

		it "should be success" do
			expect(response.status).to eq(200)
			expect(response).to render_template("index")
			expect(assigns[:books].size).not_to eq(Book.all.count)
			expect(assigns[:books].size).to eq(2)
		end
	end

	describe "404 error" do
		before do
			get :show, {:id => 99999} 
		end

		it "should redirect to not found page" do
			expect(response.status).to eq(404)
			expect(response).to render_template("error")
		end
	end			
end
