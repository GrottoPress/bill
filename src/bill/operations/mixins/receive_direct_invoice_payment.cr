# Receives payment for a given invoice; the invoice is
# marked as paid afterwards.
module Bill::ReceiveDirectInvoicePayment
  macro included
    attribute invoice_id : Invoice::PrimaryKeyType

    before_save do
      validate_invoice_open
      validate_amount_eq_invoice
    end

    after_save mark_invoice_as_paid

    getter invoice : Invoice? do
      invoice_id.value.try do |value|
        InvoiceQuery.new
          .id(value)
          .preload_line_items
          .preload_credit_notes(CreditNoteQuery.new.preload_line_items)
          .first?
      end
    end

    private def validate_invoice_open
      invoice.try do |invoice|
        return if invoice.open?

        invoice_id.add_error Rex.t(
          :"operation.error.invoice_not_open",
          invoice_id: invoice.id
        )
      end
    end

    private def validate_amount_eq_invoice
      invoice.try do |invoice|
        amount.value.try do |value|
          return if invoice.net_amount == value.abs

          amount.add_error Rex.t(
            :"operation.error.receipt_not_equal_invoice",
            amount: value,
            amount_fmt: FractionalMoney.new(value).to_s,
            amount_mu: FractionalMoney.new(value).amount_mu,
            currency_code: Bill.settings.currency.code,
            currency_sign: Bill.settings.currency.sign,
            net_amount: invoice.net_amount,
            net_amount_fmt: invoice.net_amount_fm.to_s,
            net_amount_mu: invoice.net_amount_fm.amount_mu
          )
        end
      end
    end

    private def mark_invoice_as_paid(transaction : Bill::Transaction)
      return unless TransactionStatus.now_finalized?(status)
      return unless transaction.type.receipt?

      invoice.try do |invoice|
        return unless invoice.net_amount == -transaction.amount

        InvoiceQuery.new
          .id(invoice.id)
          .is_open
          .update(status: InvoiceStatus.new(:paid))
      end
    end
  end
end
