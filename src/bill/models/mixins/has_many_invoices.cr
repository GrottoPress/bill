module Bill::HasManyInvoices
  macro included
    has_many invoices : Invoice
  end
end
