module Bill::Refunds::New
  macro included
    # get "/receipts/:receipt_id/refunds/new" do
    #   operation = RefundPayment.new(receipt: receipt)
    #   html NewPage, operation: operation
    # end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end
  end
end
