module Bill::TransactionMetadata
  macro included
    include Lucille::JSON

    getter credit_note_id : {{ CreditNote::PRIMARY_KEY_TYPE }}?
    getter invoice_id : {{ Invoice::PRIMARY_KEY_TYPE }}?
    getter receipt_id : {{ Receipt::PRIMARY_KEY_TYPE }}?
  end
end
