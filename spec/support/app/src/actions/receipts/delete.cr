class Receipts::Delete < BrowserAction
  include Bill::Receipts::Delete

  delete "/receipts/:receipt_id" do
    run_operation
  end
end
