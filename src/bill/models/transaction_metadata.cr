module Bill::TransactionMetadata
  macro included
    include Lucille::JSON

    getter credit_note_id : CreditNote::PrimaryKeyType?
  end
end
