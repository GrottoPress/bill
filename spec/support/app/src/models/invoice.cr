class Invoice < BaseModel
  include Bill::Invoice
  include Bill::BelongsToUser
  include Bill::HasManyCreditNotes
  include Bill::HasManyInvoiceItems

  table :invoices {}
end
