json.array!(@books) do |book|
  json.extract! book, :id, :title, :author_name
  json.url book_url(book, format: :json)
end
