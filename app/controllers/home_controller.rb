class HomeController < ApplicationController
  before_action :is_user_admin

  def index
  end

  private
  def is_user_admin
    if current_user
      redirect_to stocks_path
      if current_user.admin?
        redirect_to admin_index_path
      end
    end
  end
end