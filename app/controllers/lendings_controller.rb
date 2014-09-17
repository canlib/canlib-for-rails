class LendingsController < ApplicationController
	def new
		@lending = Lending.new
		@lending.build_book
		# default value
		@lending.date = Date.today
		@lending.period = 14
	end

	def create
		Lending.uniq_book_id?(params[:book_id])
    @lending = Book.find(params[:book_id]).build_lending(lending_params)

    if @lending.save
      redirect_to book_path(params[:book_id]), notice: 'Lending was successfully created.'
    else
     render 'new'
    end
	rescue
		redirect_to book_path(params[:book_id]), notice: 'This book is already rented out.'
	end

	def destroy
	end

	private

    # Never trust parameters from the scary internet, only allow the white list through.
    def lending_params
      params.require(:lending).permit(:date, :period, :user_name)
    end
end
