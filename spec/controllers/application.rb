require 'rails_helper'

describe ApplicationController, :type => :controller do
	describe "404 error" do
		subject {{:get => "/hoge"}}
		it {should route_to :controller => "application", :action => "render_error", :a => "hoge"}
	end			
end
