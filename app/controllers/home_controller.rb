class HomeController < ApplicationController
  before_action :is_user_admin

  def index
    redirect_to admin_index_path
  end

  private
  def is_user_admin
    if current_user
      redirect_to stocks_path
    end
  end
end