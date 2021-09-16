class Transactions::Show < BrowserAction
  include Bill::Transactions::Show

  get "/transactions/:transaction_id" do
    html ShowPage, transaction: transaction
  end
end
