class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /stocks or /stocks.json

  def index
    # @user_stocks = Stock.all
    @top_10_stocks = Stock.iex_api.stock_market_list(:mostactive)
    @all_stocks = Stock.iex_api.ref_data_symbols()
    @User = current_user
  end

  def search
    # SEARCH BAR
    respond_to do |format|
      begin
        if params[:symbol]
          @stock_search = Stock.iex_api.quote(params[:symbol])
          
          if @stock_search
            format.html{redirect_to stock_path(params[:symbol])}       
          end

        end

      rescue IEX::Errors::SymbolNotFoundError => e
        format.html{redirect_to stocks_path, alert: "No symbol found"}
      end
    end
  end

  # GET /stocks/1 or /stocks/1.json
 
  def show
    @stock = params[:id]
    if current_user && user_signed_in?
      @trading_history = TradingHistory.where(user_id:current_user.id)
      shares = Stock.find_by(user_id:current_user.id, name:params[:id])
      # @current_balance = current_user.balance.round(2)
    end
    @latest_price = Stock.iex_api.price(params[:id])
    @company_name = Stock.iex_api.company(params[:id]).company_name
    @company_symbol = params[:id]
    
    @company_market_cap = Stock.iex_api.key_stats(params[:id]).market_cap_dollar
    @action = 'buy'
    
      if shares
        @shares = shares.quantity
      else
        @shares = 0
      end 
  end

  #Get /stocks/buy
  def add_stock
    stock = Stock.find_by(user_id:current_user.id, name: params[:symbol])
    price = Stock.iex_api.price(params[:symbol])
    
    respond_to do |format|
      if stock && current_user.money >= price*params[:quantity].to_i
        share = stock.quantity
        current_user.money -= price*params[:quantity].to_i
        stock.update(quantity: share += params[:quantity].to_i)
        # save_to_history(params[:symbol],price, params[:quantity], 'buy', current_user.id, stock.id)

      elsif current_user.money >= price*params[:quantity].to_i
        current_user.money -= price*params[:quantity].to_i
        new_stock = Stock.new(
          name: params[:symbol],
          quantity: params[:quantity].to_i,
          user_id: current_user.id
        )
        new_stock.save
        # save_to_history(params[:symbol],price, params[:quantity], 'buy', current_user.id, new_stock.id)

      else
        format.html{redirect_to stock_path(params[:symbol]), notice: "Insufficient funds!"}
      end
      current_user.save
      format.html{redirect_to stock_path(params[:symbol]), notice: "Stock order fulfilled!"}
    end
  end

  def buy_stock

  end

  def sell_stock
    price = Stock.iex_api.price(params[:symbol])
    respond_to do |format|
      stock = Stock.find_by(user_id:current_user.id, name: params[:symbol])
      if stock && stock.quantity >= params[:quantity].to_i
        share = stock.quantity
        current_user.money += price*params[:quantity].to_i
        stock.update(quantity: share -= params[:quantity].to_i)
        current_user.save
        # save_to_history(params[:id],Stock.iex_api.price(params[:id]), params[:quantity], 'sell', current_user.id, stock.id)
      else
        format.html{redirect_to stock_path(params[:symbol]),alert:"Insufficient stocks! "}

      end
      
      format.html{redirect_to stock_path(params[:symbol]),notice:"Stock successfully sold!"}
    end
  end

  def out_stock
  
  end
  
  # GET /stocks/new
  def new
    #@stock = Stock.new
    @stock = current_user.stocks.build
  end

  # GET /stocks/1/edit
  def edit
    
  end

  # POST /stocks or /stocks.json
  def create
    # @stock = Stock.new(stock_params)
    @stock = current_user.stocks.build(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: "Stock was successfully created." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1 or /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1 or /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
    @stock = current_user.stocks.find_by(id: params[:id])
    redirect_to stocks_path, notice: "Not Authorized to Edit this stock" if @stock.nil?
  end

  def search
    redirect_to stock_path(params[:symbol])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      # @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:name, :unit_price, :shares, :user_id)
    end
end
