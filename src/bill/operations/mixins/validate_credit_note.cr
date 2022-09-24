module Bill::ValidateCreditNote
  macro included
    @invoice : Invoice?

    before_save do
      set_invoice

      validate_description_required
      validate_status_required
      validate_reference_unique
      validate_invoice_id_required
      validate_invoice_finalized
      validate_invoice_exists
    end

    include Bill::ValidateStatusTransition

    private def validate_description_required
      validate_required description,
        message: Rex.t(:"operation.error.description_required")
    end

    private def validate_status_required
      validate_required status,
        message: Rex.t(:"operation.error.status_required")
    end

    private def validate_reference_unique
      validate_uniqueness_of reference, message: Rex.t(
        :"operation.error.reference_exists",
        reference: reference.value
      )
    end

    private def validate_invoice_id_required
      validate_required invoice_id,
        message: Rex.t(:"operation.error.invoice_id_required")
    end

    private def validate_invoice_exists
      invoice_id.value.try do |value|
        return if @invoice

        invoice_id.add_error Rex.t(
          :"operation.error.invoice_not_found",
          invoice_id: value
        )
      end
    end

    private def validate_invoice_finalized
      @invoice.try do |invoice|
        return if invoice.finalized?

        invoice_id.add_error Rex.t(
          :"operation.error.invoice_not_finalized",
          invoice_id: invoice.id
        )
      end
    end

    private def set_invoice
      invoice_id.value.try do |value|
        @invoice = InvoiceQuery.new.id(value).first?
      end
    end
  end
end
