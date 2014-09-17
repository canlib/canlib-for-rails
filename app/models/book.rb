class Book < ActiveRecord::Base
	has_one :lending, dependent: :destroy
	validates :title, presence: true, length: {maximum: 50}
	validates :author_name, presence: true, length: {maximum: 30}
end
