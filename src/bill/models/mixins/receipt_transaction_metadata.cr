module Bill::ReceiptTransactionMetadata
  macro included
    getter receipt_id : Receipt::PrimaryKeyType?
  end
end
