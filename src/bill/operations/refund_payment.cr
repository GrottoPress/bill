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
        if metadata.value
          metadata.value.try &.receipt_id = receipt.id
          metadata.value = metadata.value.dup # Ensures `#changed?` is `true`
        else
          metadata.value = TransactionMetadata.from_json({
            receipt_id: receipt.id,
          }.to_json)
        end
      end
    end

    private def set_default_description
      return if description.value

      receipt.try do |receipt|
        description.value = "Refund for receipt ##{receipt.id}"
      end
    end

    private def validate_amount_lte_receipt
      return unless value = amount.value

      receipt.try do |receipt|
        if value > receipt.amount
          amount.add_error("cannot be higher than receipt amount")
        end
      end
    end

    private def validate_receipt_finalized
      receipt.try do |receipt|
        type.add_error("is not finalized") unless receipt.finalized?
      end
    end
  end
end
