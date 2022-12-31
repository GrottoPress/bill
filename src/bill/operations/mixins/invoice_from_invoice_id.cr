module Bill::InvoiceFromInvoiceId
  macro included
    getter invoice : Invoice? do
      invoice_id.value.try { |value| InvoiceQuery.new.id(value).first? }
    end
  end
end
