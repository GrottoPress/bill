class Transactions::New < BrowserAction
  include Bill::Transactions::New

  get "/transactions/new" do
    operation = CreateTransaction.new
    html NewPage, operation: operation
  end
end
