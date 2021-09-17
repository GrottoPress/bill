module Bill::ValidateCreditNote
  macro included
    @invoice : Invoice?

    before_save do
      set_invoice

      validate_description_required
      validate_status_required
      validate_invoice_id_required
      validate_invoice_finalized
      validate_invoice_exists
    end

    include Bill::ValidateStatusTransition

    private def validate_description_required
      validate_required description
    end

    private def validate_status_required
      validate_required status
    end

    private def validate_invoice_id_required
      validate_required invoice_id
    end

    private def validate_invoice_exists
      invoice_id.add_error("does not exist") unless @invoice
    end

    private def validate_invoice_finalized
      @invoice.try do |invoice|
        invoice_id.add_error("is not finalized") unless invoice.finalized?
      end
    end

    private def set_invoice
      invoice_id.value.try do |value|
        @invoice = InvoiceQuery.new.id(value).first?
      end
    end
  end
end
