class Receipts::Create < BrowserAction
  include Bill::Receipts::Create

  post "/receipts" do
    run_operation
  end
end
