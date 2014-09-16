class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale, if: :html?

  def set_locale
    accept_language = request.env['HTTP_ACCEPT_LANGUAGE'] || 'ja'
    accept_language = accept_language.slice(/^[A-Za-z\-]{2,5}/)
    if accept_language
      splitted_accept_language = accept_language.split('-')
      language = splitted_accept_language[0]
      country = splitted_accept_language[1]
      accept_language = [language, country.upcase].join('-') if country.present?
      available_locales = I18n::available_locales.map{|locale| locale.to_s }
      accept_language = available_locales.include?(accept_language) ? accept_language : accept_language[0,2]
      accept_language = available_locales.include?(accept_language) ? accept_language : I18n.default_locale
      I18n.locale = accept_language
    else
      I18n.locale = I18n.default_locale
    end
    I18n.locale
  end

	def render_error(options = {})
		status = options[:status] || 404
		@error_label = options[:error_label] || 'not_found'
		redirect_url = options[:redirect_url]

		if redirect_url.nil?
			respond_to do |format|
				format.html {render '/error', :status => status}
				format.json {render :nothing => true, :status => status}
			end
		else
			session[:error_title] = @error_label
			redirect_to redirect_url
		end
	end

  private

  def html?
    request.format.blank? || request.format == '*/*' || request.format.html?
  end

end
