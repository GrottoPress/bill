module Bill::HasManyReceipts
  macro included
    has_many receipts : Receipt
  end
end
