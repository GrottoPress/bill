class Invoice < BaseModel
  include Bill::Invoice
  include Bill::HasManyCreditNotes
  include Bill::HasManyInvoiceItems

  table :invoices {}
end
