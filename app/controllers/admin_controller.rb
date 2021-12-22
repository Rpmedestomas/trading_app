class AdminController < ApplicationController
    before_action :is_admin

    def index
        @users = User.where(admin: false)
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        @user.skip_confirmation!
            if @user.save
                redirect_to admin_index_path
                flash[:notice] = "User was successfully created."
            else
                render :new
            end
    end

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        respond_to do |format|
            if @user.update(user_params)
              format.html { redirect_to @user, notice: "User profile was successfully updated" }
            else
              format.html { render :edit, status: :unprocessable_entity }
            end
        end
    end

    private
        def user_params
            params.require(:user).permit(:email, :password, :full_name, :money)
        end

        def is_admin
            if authenticate_user! && current_user.admin
                return true
            else
                redirect_to root_path
            end
        end

end