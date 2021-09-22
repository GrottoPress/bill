class Receipts::Show < BrowserAction
  include Bill::Receipts::Show

  get "/receipts/:receipt_id" do
    html ShowPage, receipt: receipt
  end
end
