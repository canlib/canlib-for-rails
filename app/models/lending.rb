class Lending < ActiveRecord::Base
	belongs_to :book
	accepts_nested_attributes_for :book
	validates :book_id, presence: true, uniqueness: true
	validates :user_name, presence: true, length: {maximum: 25}
	validates :period, presence: true

	def self.uniq_book_id?(id)
		raise "Already rented out" if Lending.find_by(book_id: id).present?
	end
end
