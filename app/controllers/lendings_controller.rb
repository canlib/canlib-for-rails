class LendingsController < ApplicationController
	def index
		@job = params[:job] == "lending" || params[:job] == "return" ? params[:job] : "other"
		@title = t 'lending.title.' + @job
		@btn_name = t 'lending.btn_name.' + @job unless @job == "other"
		@books = case @job
		when "lending"
			Book.paginate(page: params[:page]).includes(:lending).where(:lendings => {:book_id => nil})
		when "return"
			Book.paginate(page: params[:page]).joins(:lending)
		else
			Book.paginate(page: params[:page])
		end
	end

	def new
		@lending = Lending.new
		@book_id = params[:book_select]
		@lending.build_book
		# default value
		@lending.date = Date.today
		@lending.period = 14
	end

	def create
		Lending.uniq_book_id?(params[:book_id])
    @lending = Book.find(params[:book_id]).build_lending(lending_params)
		@lending.date = Date.today
		@lending.period = 14

    if @lending.save
			redirect_to_back("/lendings?job=lending", notice: (t 'alert.success.lending_create'))
    else
			redirect_to_back("/lendings?job=lending", alert: (t 'alert.error.lending_create.rollback'))
    end
	rescue
		redirect_to_back("/lendings?job=lending", alert: (t 'alert.error.lending_create.other'))
	end

	def destroy
    @lending = Lending.find_by(book_id: params[:book_id])
		if @lending.present?
			@lending.destroy
	    redirect_to_back("/lendings?job=return", notice: (t 'alert.success.lending_delete'))
		else
			redirect_to_back("/lendings?job=return", alert: (t 'alert.error.lending_delete'))
		end
	end

	private

    # Never trust parameters from the scary internet, only allow the white list through.
    def lending_params
      params.require(:lending).permit(:date, :period, :user_name)
    end

end
