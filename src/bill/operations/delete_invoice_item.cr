module Bill::DeleteInvoiceItem
  macro included
    before_delete do
      validate_not_finalized
    end

    private def validate_not_finalized
      return unless record.invoice.finalized?
      invoice_id.add_error("is finalized")
    end
  end
end
