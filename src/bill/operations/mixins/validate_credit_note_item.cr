module Bill::ValidateCreditNoteItem
  macro included
    include Bill::SetDefaultQuantity
    include Bill::CreditNoteFromCreditNoteId

    skip_default_validations

    before_save do
      validate_credit_note_id_required
      validate_description_required
      validate_price_required

      validate_price_gt_zero
      validate_quantity_gt_zero

      validate_credit_note_exists
    end

    after_save validate_credit_lte_invoice

    include Bill::ValidateDescription

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

    private def validate_credit_lte_invoice(
      credit_note_item : Bill::CreditNoteItem
    )
      return unless quantity.changed? || price.changed?

      credit_note_item = CreditNoteItemQuery.preload_credit_note(
        credit_note_item,
        CreditNoteQuery.new.preload_invoice
      )

      credit_note = credit_note_item.credit_note
      invoice_amount = credit_note.invoice.net_amount
      credit_amount = credit_note.amount!

      return if credit_amount <= invoice_amount

      balance = invoice_amount - credit_amount
      current_amount = credit_note_item.amount

      id.add_error Rex.t(
        :"operation.error.credit_exceeds_invoice",
        amount: current_amount,
        amount_fmt: FractionalMoney.new(current_amount).to_s,
        amount_mu: FractionalMoney.new(current_amount).amount_mu,
        balance: balance,
        balance_fmt: FractionalMoney.new(balance).to_s,
        balance_mu: FractionalMoney.new(balance).amount_mu,
        currency_code: Bill.settings.currency.code,
        currency_sign: Bill.settings.currency.sign
      )

      {%if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
        write_database.rollback
      {% else %}
        database.rollback
      {% end %}
    end
  end
end
