class Transaction < BaseModel
  include Bill::Transaction
  include Bill::BelongsToUser
  include Bill::CreditNoteTransactionSource
  include Bill::InvoiceTransactionSource
  include Bill::ReceiptTransactionSource

  skip_default_columns
  primary_key id : Int64

  table :transactions do
    column created_at : Time
  end
end
