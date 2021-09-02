class InvoiceItem < BaseModel
  include Bill::InvoiceItem

  table :invoice_items {}
end
