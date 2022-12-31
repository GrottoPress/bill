module Bill::ValidateCreditNoteItem
  macro included
    include Bill::SetDefaultQuantity
    include Bill::CreditNoteFromCreditNoteId

    before_save do
      validate_credit_note_id_required
      validate_description_required
      validate_price_required

      validate_price_gt_zero
      validate_quantity_gt_zero

      validate_credit_note_exists
      validate_credit_lte_invoice
    end

    private def validate_credit_note_id_required
      validate_required credit_note_id,
        message: Rex.t(:"operation.error.credit_note_id_required")
    end

    private def validate_description_required
      validate_required description,
        message: Rex.t(:"operation.error.description_required")
    end

    private def validate_price_required
      validate_required price,
        message: Rex.t(:"operation.error.price_required")
    end

    private def validate_price_gt_zero
      price.value.try do |value|
        return if value > 0
        price.add_error Rex.t(:"operation.error.price_lte_zero", price: value)
      end
    end

    private def validate_quantity_gt_zero
      quantity.value.try do |value|
        return if value > 0

        quantity.add_error Rex.t(
          :"operation.error.quantity_lte_zero",
          quantity: value
        )
      end
    end

    private def validate_credit_note_exists
      return unless credit_note_id.changed?

      credit_note_id.value.try do |value|
        return if credit_note

        credit_note_id.add_error Rex.t(
          :"operation.error.credit_note_not_found",
          credit_note_id: value
        )
      end
    end

    private def validate_credit_lte_invoice
      quantity.value.try do |_quantity|
        price.value.try do |_price|
          return unless quantity.changed? || price.changed?

          credit_note.try do |credit_note|
            credit_note = CreditNoteQuery.preload_invoice(credit_note)

            invoice_amount = credit_note.invoice.net_amount
            current_credits = credit_note.amount!
            record.try { |record| current_credits -= record.amount }

            current_item_amount = _quantity * _price
            balance = invoice_amount - current_credits

            if current_item_amount > balance
              id.add_error Rex.t(
                :"operation.error.credit_exceeds_invoice",
                amount: current_item_amount,
                amount_mu: FractionalMoney.new(current_item_amount).amount_mu,
                balance: balance,
                balance_mu: FractionalMoney.new(balance).amount_mu
              )
            end
          end
        end
      end
    end
  end
end
