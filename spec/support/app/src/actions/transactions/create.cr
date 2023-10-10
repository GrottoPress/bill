class Transactions::Create < BrowserAction
  include Bill::Transactions::Create

  post "/transactions" do
    run_operation
  end
end
