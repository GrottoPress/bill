module Bill::FinalizedReceipts::Edit
  macro included
    # get "/receipts/:receipt_id/finalized/edit" do
    #   operation = UpdateFinalizedReceipt.new(receipt)
    #   html EditPage, operation: operation
    # end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end
  end
end
