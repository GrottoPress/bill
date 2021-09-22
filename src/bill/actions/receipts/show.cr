module Bill::Receipts::Show
  macro included
    # get "/receipts/:receipt_id" do
    #   html ShowPage, receipt: receipt
    # end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end
  end
end
