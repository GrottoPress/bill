module Bill::ReceiptsStatus::Edit
  macro included
    # get "/receipts/:receipt_id/status/edit" do
    #   operation = UpdateReceiptStatus.new(receipt)
    #   html EditPage, operation: operation
    # end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end
  end
end
