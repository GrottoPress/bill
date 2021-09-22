# Receives payment without creating a `Receipt` record
module Bill::ReceiveDirectPayment
  macro included
    include Bill::CreateCreditTransaction

    before_save do
      set_type
    end

    private def set_type
      type.value = TransactionType.new(:receipt)
    end
  end
end
