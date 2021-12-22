class Stock < ApplicationRecord
    belongs_to :user

    def self.iex_api
        IEX::Api::Client.new(
            publishable_token: 'Tpk_56239b188cb9496582b11d81b697b5dc',
            secret_token: 'Tsk_4a38760a92b24b4fa29e03c76d920209',
            endpoint: 'https://sandbox.iexapis.com/v1'
        )
    end
end
