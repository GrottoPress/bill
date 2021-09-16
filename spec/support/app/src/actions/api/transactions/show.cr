class Api::Transactions::Show < ApiAction
  include Bill::Api::Transactions::Show

  get "/transactions/:transaction_id" do
    json({
      status: "success",
      data: {transaction: TransactionSerializer.new(transaction)}
    })
  end
end
