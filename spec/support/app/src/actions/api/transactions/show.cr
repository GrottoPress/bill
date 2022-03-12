class Api::Transactions::Show < ApiAction
  include Bill::Api::Transactions::Show

  get "/transactions/:transaction_id" do
    json ItemResponse.new(transaction: transaction)
  end
end
