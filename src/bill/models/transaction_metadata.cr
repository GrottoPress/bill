module Bill::TransactionMetadata
  macro included
    include Bill::Metadata

    property credit_note_id : Int64?
    property invoice_id : Int64?
    property receipt_id : Int64?
  end
end
