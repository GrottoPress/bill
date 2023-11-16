module Bill::InvoiceTransactionMetadata
  macro included
    getter invoice_id : Invoice::PrimaryKeyType?
  end
end
