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
		@search_string = params[:search_string]
		@job = case params[:job]
		when "lending", "return"
			params[:job]
		when nil
			nil
		else
			"other"
		end
		@title = @job.nil? ? (t 'books.title') : (t 'lending.title.' + @job)

		@all_books = case @job
		when "lending"
			Book.includes(:lending).where(:lendings => {:book_id => nil})
		when "return"
			Book.joins(:lending)
		else
			Book.all
		end
		@books = @all_books.where("title LIKE ?", "%#{Book.escape_like(params[:search_string])}%").paginate(page: params[:page])

		if @all_books.count == 0 || @books.count == 0
			@result = t 'search.result.nothing', :word => @search_string
		elsif @books.count == 1
			@result = t 'search.result.hit', :hit => "1", :all => @all_books.count.to_s, :word => @search_string
		else
			@result = t 'search.result.hits', :hit => @books.count.to_s, :all => @all_books.count.to_s, :word => @search_string
		end

		if @job.nil?
			@add_btn_name = t 'books.btn_name.add'
			@show_btn_name = t 'books.btn_name.show'
			@delete_btn_name = t 'books.btn_name.delete'
			render 'books/index' 
		else
			@btn_name = t 'lending.btn_name.' + @job
			render 'lendings/index'
		end
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
