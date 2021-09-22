module Bill::Receipts::Edit
  macro included
    # get "/receipts/:receipt_id/edit" do
    #   operation = UpdateReceipt.new(receipt)
    #   html EditPage, operation: operation
    # end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end
  end
end
