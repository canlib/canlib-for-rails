# encoding: utf-8

module HtmlSelectorsHelpers
  SELECTORS = {
    '404エラー' => 'div.error',
		'ラジオボタン' => 'input[type=radio]',
		'書籍タイトル' => 'td.book_title',
		'著者名' => 'td.book_author',
		'書籍タイトルフォーム' => 'book[title]',
		'著者名フォーム' => 'book[author_name]',
		'利用者名フォーム' => 'lending[user_name]',
		'貸出ボタン' => '#lending_book_button',
		'返却ボタン' => '#return_book_button',
		'登録ボタン' => '#add_book_button',
		'編集ボタン' => '#show_book_button',
		'削除ボタン' => '#delete_book_button',
		'ハイライトメッセージ' => 'p.ui-state-highlight',
		'2ページ目' => 'a[href="/books?page=2"]'
  }
  def selector_for(locator)
    unless SELECTORS[locator].nil?
      SELECTORS[locator]
    else
      nil
    end
  end
end

World(HtmlSelectorsHelpers)
