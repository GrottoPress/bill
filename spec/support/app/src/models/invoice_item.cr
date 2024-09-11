class InvoiceItem < BaseModel
  include Bill::InvoiceItem
  include Bill::BelongsToInvoice

  table :invoice_items {}
end
