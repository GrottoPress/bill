module Bill::BelongsToReceipt
  macro included
    belongs_to receipt : Receipt
  end
end
