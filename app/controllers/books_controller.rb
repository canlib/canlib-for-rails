class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]


  # GET /books
  # GET /books.json
  def index
    @books = Book.paginate(page: params[:page])
		@title = t 'books.title'
		@add_btn_name = t 'books.btn_name.add'
		@show_btn_name = t 'books.btn_name.show'
		@delete_btn_name = t 'books.btn_name.delete'
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to_back(books_path, notice: (t 'alert.success.book_add')) }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { redirect_to_back(books_path, alert: (t 'alert.error.book_add')) }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
		if @book.lending.present?
			redirect_to edit_book_path, alert: (t 'alert.error.book_update.rented_out')
		else
    	respond_to do |format|
      	if @book.update(book_params)
       	 format.html { redirect_to edit_book_path, notice: (t 'alert.success.book_update') }
        	format.json { render :edit, status: :ok, location: @book }
      	else
        	format.html { redirect_to edit_book_path, alert: (t 'alert.error.book_update.other') }
        	format.json { render json: @book.errors, status: :unprocessable_entity }
      	end
    	end
		end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to_back(books_path, notice: (t 'alert.success.book_delete')) }
      format.json { head :no_content }
    end
  end

	def search
		@title = t 'books.title'
		@add_btn_name = t 'books.btn_name.add'
		@show_btn_name = t 'books.btn_name.show'
		@delete_btn_name = t 'books.btn_name.delete'
		@books = Book.where("title LIKE ?", "%#{Book.escape_like(params[:search_string])}%").paginate(page: params[:page])
		render :index
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			options = {status: 404, error_label: 'not_found'}
			render_error(options)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :author_name)
    end

end
