module Bill::RefundPayment # Transaction::SaveOperation
  macro included
    needs receipt : Receipt?

    before_save do
      set_type
      set_credit
      set_user_id
      set_amount
      set_source
      set_default_description

      validate_amount_lte_receipt
      validate_receipt_finalized
    end

    include Bill::CreateTransaction

    private def set_type
      type.value = TransactionType.new(:receipt)
    end

    private def set_credit
      credit.value = false
    end

    private def set_amount
      return unless amount.value.nil?
      receipt.try { |receipt| amount.value = receipt.amount }
    end

    private def set_user_id
      receipt.try { |receipt| user_id.value = receipt.user_id }
    end

    private def set_source
      receipt.try do |receipt|
        source.value = receipt.id.to_s
      end
    end

    private def set_default_description
      return unless description.value.nil?

      receipt.try do |receipt|
        description.value = Rex.t(
          :"operation.misc.refund_description",
          reference: receipt.reference
        )
      end
    end

    private def validate_amount_lte_receipt
      amount.value.try do |value|
        receipt.try do |receipt|
          return if value <= receipt.amount

          amount.add_error Rex.t(
            :"operation.error.refund_exceeds_receipt",
            amount: value,
            amount_fmt: FractionalMoney.new(value).to_s,
            amount_mu: FractionalMoney.new(value).amount_mu,
            currency_code: Bill.settings.currency.code,
            currency_sign: Bill.settings.currency.sign,
            receipt_amount: receipt.amount,
            receipt_amount_fmt: receipt.amount_fm.to_s,
            receipt_amount_mu: receipt.amount_fm.amount_mu
          )
        end
      end
    end

    private def validate_receipt_finalized
      receipt.try do |receipt|
        return if receipt.finalized?

        status.add_error Rex.t(
          :"operation.error.receipt_not_finalized",
          receipt_id: receipt.id
        )
      end
    end
  end
end
