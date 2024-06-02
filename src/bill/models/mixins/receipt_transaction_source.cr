module Bill::ReceiptTransactionSource
  macro included
    def receipt_id : Receipt::PrimaryKeyType?
      return unless type.receipt?
      Receipt::PrimaryKeyType.adapter.parse!(source)
    end

    def receipt! : Receipt?
      receipt_id.try { |id| ReceiptQuery.find(id) }
    end
  end
end
