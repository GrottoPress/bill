module Bill::InvoiceFromInvoiceId
  macro included
    {% unless @type.methods.find(&.name.== :invoice.id) %}
      getter invoice : Invoice? do
        invoice_id.value.try { |value| InvoiceQuery.new.id(value).first? }
      end
    {% end %}
  end
end
