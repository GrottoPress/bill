module Bill::OptionalBelongsToInvoice
  macro included
    belongs_to invoice : Invoice?
  end
end
