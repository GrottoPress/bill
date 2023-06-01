module Bill::ValidateCreditNote
  macro included
    include Bill::InvoiceFromInvoiceId

    skip_default_validations

    before_save do
      validate_status_required
      validate_invoice_id_required
      validate_invoice_finalized
      validate_invoice_exists
    end

    include Bill::ValidateStatusTransition
    include Bill::ValidateReference

    private def validate_status_required
      validate_required status,
        message: Rex.t(:"operation.error.status_required")
    end

    private def validate_invoice_id_required
      validate_required invoice_id,
        message: Rex.t(:"operation.error.invoice_id_required")
    end

    private def validate_invoice_exists
      return unless invoice_id.changed?

      invoice_id.value.try do |value|
        return if invoice

        invoice_id.add_error Rex.t(
          :"operation.error.invoice_not_found",
          invoice_id: value
        )
      end
    end

    private def validate_invoice_finalized
      invoice.try do |invoice|
        return if invoice.finalized?

        invoice_id.add_error Rex.t(
          :"operation.error.invoice_not_finalized",
          invoice_id: invoice.id
        )
      end
    end
  end
end
