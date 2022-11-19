module Bill::OptionalBelongsToReceipt
  macro included
    belongs_to receipt : Receipt?
  end
end
