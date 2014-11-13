# encoding: utf-8

もし /^"([^\"]*)"ページを表示している$/ do |page_name|
	visit path_to(page_name)
end

もし /^クエリ"(.*?)"で"(.*?)"ページを表示している$/ do |query, page_name|
	if query == "なし"
		step %{"#{page_name}"ページを表示する}
	else
		visit path_to(page_name) + "?" + query.to_s
	end
end

もし /^"([0-9]+)"番目の書籍のラジオボタンを選択している$/ do |num|
	choose Book.find(num).id
end

もし /^"([^\"]*)"をクリックする$/ do |elements|
	find_button(elements).trigger('click')
end

もし /^タブを切り替える$/ do
	handle = page.driver.browser.window_handles.last
	page.driver.browser.within_window(handle) do
	end
end	

dialog_selector = {
	'書籍登録' => 'div[aria-describedby="add-book-dialog-form"]',
	'書籍削除' => 'div[aria-describedby="delete-dialog-confirm"]',
	'貸出処理' => 'div[aria-describedby="lending-dialog-form"]',
	'返却処理' => 'div[aria-describedby="lending-dialog-confirm"]'
}

もし /^"(.*?)"ダイアログの"(.*?)"をクリックする$/ do |dialog, button|
	within("#{dialog_selector[dialog]}") do
		find_button(button).click
	end
end

もし /^"(.*?)"に"(.*?)"と入力する$/ do |form, string|
	fill_in(selector_for(form), with: string)
end

もし /^"(.*?)"ページの"([0-9]+)"ページ目を表示する$/ do |page_name, page_num|
	step %{クエリ"page=#{page_num}"で"#{page_name}"ページを表示している}
end

もし /^"(.*?)"リンクをクリックする$/ do |link|
	find_link(link).click
end

ならば /^"(.*?)"ページの"([0-9]+)"ページ目へ移動すること$/ do |page_name, page_num|
	uri = URI.parse(current_url)
	expect("#{uri.path}?#{uri.query}").to eq(path_to(page_name) + "?page=" + page_num)
end

ならば /^"(.*?)"に"(.*?)"が表示されること$/ do |element, string|
	expect(find(selector_for(element))).to have_content(string)
end

ならば /^"(.*?)"ダイアログに"(.*?)"が表示されていること$/ do |dialog, element|
	expect(find(dialog_selector[dialog].to_s)).to have_selector(selector_for(element))
end

ならば /^タイトルは"(.*?)"であること$/ do |title|
	expect(page).to have_title(title)
end

ならば /^"([^\"]*)"が表示されていること$/ do |element|
	expect(page).to have_selector(selector_for(element))
end

ならば /^"([^\"]*)"が表示されていないこと$/ do |element|
	expect(page).not_to have_selector(selector_for(element))
end

ならば /^一覧の"(.*?)"の"([0-9]+)"番目に文字列"([^\"]*)"が表示されていること$/ do |element, position, string|
	expect(all(selector_for(element))[position.to_i - 1]).to have_content(string)
end

ならば /^一覧の"(.*?)"の"([0-9]+)"番目に文字列"([^\"]*)"が表示されていないこと$/ do |element, position, string|
	expect(all(selector_for(element))[position.to_i - 1]).not_to have_content(string)
end

ならば /^以下の項目が(表示|要素に付加)されていること$/ do |condition, elements|
	elements.hashes.each do |row|
		selector = selector_for row['項目']
		if selector.nil?
			expect(page).to have_content(row['項目'])
		else
			expect(page).to have_selector(selector_for(row['項目']))
		end
	end
end

ならば /^"(.*?)"が有効になっていること$/ do |button|
	expect(page).to have_no_css(selector_for(button) + '[disabled="disabled"]')
end

ならば /^"(.*?)"が無効になっていること$/ do |button|
	expect(page).to have_css(selector_for(button) + '[disabled="disabled"]')
end

ならば /^"(.*?)"ダイアログが表示されること$/ do |dialog|
	expect(find("#{dialog_selector[dialog]}")).to be_visible
end

ならば /^"(.*?)"ダイアログが表示されていること$/ do |dialog|
	step %{"#{dialog}"ダイアログが表示されること}
end

ならば /^"(.*?)"ダイアログが閉じること$/ do |dialog|
	expect(find("#{dialog_selector[dialog]}")).not_to be_visible
end

ならば /^1番目の書籍の"(.*?)"ページを表示すること$/ do |page_name|
	handle = page.driver.browser.window_handles.last
	page.driver.browser.within_window(handle) do
		book_id = Book.first.id
		expect(current_path).to eq(path_to(page_name, book_id))
	end
end

