class Api::Transactions::Show < ApiAction
  include Bill::Api::Transactions::Show

  get "/transactions/:transaction_id" do
    json TransactionSerializer.new(transaction: transaction)
  end
end
