module ApplicationHelper

	def full_title(page_title)
		base_title = I18n.t 'app_name' 
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end
	
	def radio_add_params(book)
		lending_params = book.lending.present? ? " lending_id=#{book.lending.id} lending_user=#{book.lending.user_name.to_s}" : "\s"
		raw "<input type='radio' id=#{book.id} name='book_select' book_id=#{book.id} book_title=#{book.title.to_s} book_author=#{book.author_name.to_s}" + lending_params + "></input>"
	end

end
