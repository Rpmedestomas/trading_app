class AdminController < ApplicationController
    before_action :is_user_admin

    def index
        @users = User.where(admin: false)
    end

    def show
        @user = User.find(params[:id])
        if params[:symbol] && params[:symbol] != ""
            @stocks = Stock.where(user_id: @user, name:params[:symbol])
            if @stocks == []
                @stocks = Stock.where(user_id: @user)
            end
        else 
            @stocks = Stock.where(user_id: @user)
        end
  
          total_balance = current_user.money
  
        @stocks.each do |stock|
            total_balance += Stock.iex_api.price(stock.name)*stock.quantity
        end
  
        @total = total_balance.round(2)
    end
    
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            redirect_to admin_index_path
            flash[:notice] = "User was successfully created."
        else
            render :new
        end
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

    def approve_user

    end

    def reject_user

    end

    def approve_status
        user = User.find(params[:id])
        user.update(:user_status => "Approved")
        user.save
        flash[:notice] = "User status updated."
        redirect_to admin_index_path
    end

    def reject_status
        user = User.find(params[:id])
        user.update(:user_status => "Rejected")
        user.save
        flash[:notice] = "User status updated."
        redirect_to admin_index_path
    end

    def portfolio 
         
        if params[:symbol] && params[:symbol] != ""
            @stocks = Stock.where(user_id: current_user.id, name:params[:symbol])
            if @stocks == []
                @stocks = Stock.where(user_id: current_user.id)
            end
        else 
            @stocks = Stock.where(user_id: current_user.id)
        end
  
          total_balance = current_user.money
  
        @stocks.each do |stock|
            total_balance += Stock.iex_api.price(stock.name)*stock.quantity
        end
  
        @total = total_balance.round(2)
    end
  

    private
        def user_params
            params.require(:user).permit(:email, :password, :money, :full_name, :user_status)
        end

        def is_user_admin
            if authenticate_user! && current_user.admin
                return true
            else
                redirect_to root_path
            end
        end
end
