module Bill::RefundPayment
  macro included
    needs receipt : Receipt?

    before_save do
      set_type
      set_user_id
      set_amount
      set_metadata
      set_default_description

      validate_amount_lte_receipt
      validate_receipt_finalized
    end

    include Bill::CreateDebitTransaction

    private def set_type
      type.value = TransactionType.new(:receipt)
    end

    private def set_amount
      return if amount.value
      receipt.try { |receipt| amount.value = receipt.amount }
    end

    private def set_user_id
      receipt.try { |receipt| user_id.value = receipt.user_id }
    end

    private def set_metadata
      receipt.try do |receipt|
        metadata.value.try do |value|
          return metadata.value = value.merge(receipt_id: receipt.id)
        end

        metadata.value = TransactionMetadata.from_json({
          receipt_id: receipt.id,
        }.to_json)
      end
    end

    private def set_default_description
      return if description.value

      receipt.try do |receipt|
        description.value = Rex.t(
          :"operation.misc.refund_description",
          reeipt_id: receipt.id
        )
      end
    end

    private def validate_amount_lte_receipt
      return unless value = amount.value

      receipt.try do |receipt|
        if value > receipt.amount
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
