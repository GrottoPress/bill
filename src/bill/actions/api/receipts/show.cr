module Bill::Api::Receipts::Show
  macro included
    # get "/receipts/:receipt_id" do
    #   json ItemResponse.new(receipt: receipt)
    # end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end
  end
end
