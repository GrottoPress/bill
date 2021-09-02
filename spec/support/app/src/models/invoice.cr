class Invoice < BaseModel
  include Bill::Invoice

  table :invoices {}
end
