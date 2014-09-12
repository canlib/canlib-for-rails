class Book < ActiveRecord::Base
	validates :title, presence: true, length: {maximum: 50}
	validates :author_name, presence: true, length: {maximum: 30}
end
