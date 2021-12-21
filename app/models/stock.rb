class Stock < ApplicationRecord
    belongs_to :user

    def self.iex_api
        IEX::Api::Client.new(
            publishable_token: 'pk_4a980d42b6a441d4ab95cc2e2f12166a',
            secret_token: 'sk_024a590056d949b69e0959f7221168d3',
            endpoint: 'https://sandbox.iexapis.com/v1'
        )
    end


end
