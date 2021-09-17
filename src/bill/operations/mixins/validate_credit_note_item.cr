module Bill::ValidateCreditNoteItem
  macro included
    include Bill::SetDefaultQuantity

    @credit_note : CreditNote?

    before_save do
      set_credit_note

      validate_credit_note_id_required
      validate_description_required
      validate_price_required

      validate_price_gt_zero
      validate_quantity_gt_zero
      validate_not_finalized

      validate_credit_note_exists
      validate_credit_lte_invoice
    end

    private def validate_credit_note_id_required
      validate_required credit_note_id
    end

    private def validate_description_required
      validate_required description
    end

    private def validate_price_required
      validate_required price
    end

    private def validate_price_gt_zero
      price.value.try do |value|
        price.add_error("must be greater than zero") if value <= 0
      end
    end

    private def validate_quantity_gt_zero
      quantity.value.try do |value|
        quantity.add_error("must be greater than zero") if value <= 0
      end
    end

    private def validate_not_finalized
      record.try do |credit_note_item|
        return unless credit_note_item.credit_note.finalized?
        credit_note_id.add_error("is finalized")
      end
    end

    private def validate_credit_note_exists
      credit_note_id.add_error("does not exist") unless @credit_note
    end

    private def validate_credit_lte_invoice
      return unless quantity.value && price.value
      return unless quantity.changed? || price.changed?

      @credit_note.try do |credit_note|
        invoice = credit_note.invoice

        invoice_amount = invoice.net_amount!
        current_credits = credit_note.amount!
        record.try { |record| current_credits -= record.amount }

        current_item_amount = quantity.value.not_nil! * price.value.not_nil!
        balance = invoice_amount - current_credits

        if current_item_amount > balance
          id.add_error("amount cannot exceed #{balance}")
        end
      end
    end

    private def set_credit_note
      credit_note_id.value.try do |value|
        @credit_note = CreditNoteQuery.new.id(value).preload_invoice.first?
      end
    end
  end
end
