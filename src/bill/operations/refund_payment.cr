module Bill::RefundPayment
  macro included
    needs receipt : Receipt?

    before_save do
      set_type
      set_credit
      set_user_id
      set_amount
      set_metadata
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

    private def set_metadata
      receipt.try do |receipt|
        values = {receipt_id: receipt.id}

        metadata.value.try do |value|
          return metadata.value = value.merge(**values)
        end

        metadata.value = TransactionMetadata.from_json(values.to_json)
      end
    end

    private def set_default_description
      return unless description.value.nil?

      receipt.try do |receipt|
        description.value = Rex.t(
          :"operation.misc.refund_description",
          reeipt_id: receipt.id
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
            amount_mu: FractionalMoney.new(value).amount_mu,
            receipt_amount: receipt.amount,
            receipt_amount_mu: receipt.amount_fm.amount_mu
          )
        end
      end
    end

    private def validate_receipt_finalized
      receipt.try do |receipt|
        return if receipt.finalized?

        type.add_error Rex.t(
          :"operation.error.receipt_not_finalized",
          receipt_id: receipt.id
        )
      end
    end
  end
end
