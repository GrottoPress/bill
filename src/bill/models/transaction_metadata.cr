module Bill::TransactionMetadata
  macro included
    include Lucille::JSON

    getter credit_note_id : Int64?
    getter invoice_id : Int64?
    getter receipt_id : Int64?
  end
end
