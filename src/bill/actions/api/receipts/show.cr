module Bill::Api::Receipts::Show
  macro included
    # get "/receipts/:receipt_id" do
    #   json({
    #     status: "success",
    #     data: {receipt: ReceiptSerializer.new(receipt)}
    #   })
    # end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end
  end
end
