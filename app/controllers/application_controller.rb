class ApplicationController < ActionController::Base
  before_action :call_github

  def call_github
    @api_info = ApiInfo.instance
  end
end
