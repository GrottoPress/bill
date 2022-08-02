module Bill::TransactionMetadata
  macro included
    include Lucille::JSON

    getter credit_note_id : CreditNote::PrimaryKeyType?
    getter invoice_id : Invoice::PrimaryKeyType?
    getter receipt_id : Receipt::PrimaryKeyType?
  end
end
