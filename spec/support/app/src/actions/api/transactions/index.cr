class Api::Transactions::Index < ApiAction
  include Bill::Api::Transactions::Index

  param page : Int32 = 1

  get "/transactions" do
    json TransactionSerializer.new(transactions: transactions, pages: pages)
  end
end
