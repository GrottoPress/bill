class Api::Receipts::Index < ApiAction
  include Bill::Api::Receipts::Index

  param page : Int32 = 1

  get "/receipts" do
    json({
      status: "success",
      data: {receipts: ReceiptSerializer.for_collection(receipts)},
      pages: PaginationSerializer.new(pages)
    })
  end
end
