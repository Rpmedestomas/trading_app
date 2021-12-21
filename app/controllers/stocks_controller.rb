class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /stocks or /stocks.json

  def index
    # @user_stocks = Stock.all
    @top_10_stocks = Stock.iex_api.stock_market_list(:mostactive)
    @all_stocks = Stock.iex_api.ref_data_symbols()
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
    if current_user && current_user.is_approved && user_signed_in?
      @trading_history = TradingHistory.where(user_id:current_user.id)
      shares = Stock.find_by(user_id:current_user.id, name:params[:id])
      @current_balance = current_user.balance.round(2)
    end
    @latest_price = Stock.iex_api.price(params[:id])
    @company_name = Stock.iex_api.company(params[:id]).company_name
    @company_symbol = params[:id]
    
    @company_market_cap = Stock.iex_api.key_stats(params[:id]).market_cap_dollar
    @action = 'buy'
    
      if shares
        @shares = shares.shares
      else
        @shares = 0
      end
    
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:name, :unit_price, :shares, :user_id)
    end
end
