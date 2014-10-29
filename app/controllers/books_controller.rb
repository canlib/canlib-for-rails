class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.paginate(page: params[:page])	
		@add_btn_name = t 'books.btn_name.add'
		@show_btn_name = t 'books.btn_name.show'
		@delete_btn_name = t 'books.btn_name.delete'

		case params[:view]
		when "m"
			@page_title = t 'books.title.index'
			render "index_m", :layout => "application_m"
		else
			render :index
		end
  end

  # GET /books/1
  # GET /books/1.json
  def show
		case params[:view]
		when "m"
			@page_title = t 'books.title.detail'
			render "show_m", :layout => "application_m"
		else
			render :show
		end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
		case params[:view]
		when "m"
			@page_title = t 'books.title.edit'
			render "edit_m", :layout => "application_m"
		else
			render :edit
		end
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html {	
					case params[:view]
					when "m"
						redirect_to root_path(view: "m"), notice: (t 'alert.success.book_add')
					else
						redirect_to_back(books_path, notice: (t 'alert.success.book_add'))
					end
				}
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
		case params[:view]
		when "m"
		  respond_to do |format|
			 	if @book.update(book_params)
					format.html { redirect_to_back(edit_book_path, notice: (t 'alert.success.book_update')) }
					format.json { render :edit, status: :ok, location: @book }
				else
			  	format.html { redirect_to_back(edit_book_path, alert: (t 'alert.error.book_update.other')) }
					format.json { render json: @book.errors, status: :unprocessable_entity }
				end
			end
		else
			if @book.lending.present?
				redirect_to edit_book_path, alert: (t 'alert.error.book_update.rented_out')
			else
		  	respond_to do |format|
			  	if @book.update(book_params)
						format.html { redirect_to_back(edit_book_path, notice: (t 'alert.success.book_update')) }
						format.json { render :edit, status: :ok, location: @book }
					else
				  	format.html { redirect_to_back(edit_book_path, alert: (t 'alert.error.book_update.other')) }
						format.json { render json: @book.errors, status: :unprocessable_entity }
					end
				end
			end
		end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html {
				case params[:view]
				when "m"
					redirect_to root_path(view: params[:view]), notice: (t 'alert.success.book_delete')
				else
					redirect_to_back(books_path, notice: (t 'alert.success.book_delete'))
				end
			}
      format.json { head :no_content }
    end
  end

	def search
		if params[:search_string].nil?
			redirect_to root_path(view: params[:view])
			return	
		end

		books = Book.arel_table
		lendings = Lending.arel_table

		@search_string = Book.escape_like(params[:search_string])
		
		title_search = books[:title].matches("\%#{@search_string}\%")
		author_search = books[:author_name].matches("\%#{@search_string}\%")
		books_sel = title_search.or(author_search)

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
			Book.includes(:lending)
		end
		@books = @all_books.where(books_sel).paginate(page: params[:page])

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
			case params[:view]
			when "m"
				render "books/index_m", :layout => "application_m"
			else
				render 'books/index' 
			end
		else
			@btn_name = t 'lending.btn_name.' + @job
			case params[:view]
			when "m"
				render "books/index_m", :layout => "application_m"
			else
				render 'lendings/index'
			end
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
