module Bill::BelongsToInvoice
  macro included
    belongs_to invoice : Invoice
  end
end
