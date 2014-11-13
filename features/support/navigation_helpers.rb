# encoding: utf-8

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name, book_id=1, lending_id=1)
    case page_name
    when /^トップ$/, /^Top$/, /^the home\s?page$/, 'トップロゴ'
      '/'
		when /^蔵書一覧$/
			'/books'
		when /^書籍詳細$/, /^書籍編集$/
			'/books/' + book_id.to_s + '/edit'
		when /^貸出処理$/
			'/lendings?job=lending'
		when /^返却処理$/
			'/lendings?job=return'
    when /^存在しない$/
      '/unexist'
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
