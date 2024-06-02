module Bill::InvoiceTransactionSource
  macro included
    def invoice_id : Invoice::PrimaryKeyType?
      return unless type.invoice?
      Invoice::PrimaryKeyType.adapter.parse!(source)
    end

    def invoice! : Invoice?
      invoice_id.try { |id| InvoiceQuery.find(id) }
    end
  end
end
