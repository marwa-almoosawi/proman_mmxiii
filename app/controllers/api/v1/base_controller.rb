class Api::V1::BaseController < ActionController::Base
  respond_to :json

  before_filter :authenticate_user

  private
    def authenticate_user
      @current_user = User.where(authentication_token: params[:token]).first
    end

    def current_user
      @current_user
    end
end