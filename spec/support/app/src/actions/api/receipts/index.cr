class Api::Receipts::Index < ApiAction
  include Bill::Api::Receipts::Index

  param page : Int32 = 1

  get "/receipts" do
    json ReceiptSerializer.new(receipts: receipts, pages: pages)
  end
end
