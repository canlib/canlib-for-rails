json.array! @books do |book|
	json.set! :book do
		json.title book.title
		json.author_name book.author_name
	end
	if book.lending.blank?
		json.lending nil
	else
		json.set! :lending do
			json.date book.lending.date
			json.period book.lending.period
			json.user_name book.lending.user_name
		end
	end
end
