class Receipts::Update < BrowserAction
  include Bill::Receipts::Update

  patch "/receipts/:receipt_id" do
    run_operation
  end
end
