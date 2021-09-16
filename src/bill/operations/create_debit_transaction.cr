module Bill::CreateDebitTransaction
  macro included
    include Bill::CreateTransaction

    before_save do
      set_amount
    end

    private def set_amount
      amount.value.try do |value|
        amount.value = value.abs
      end
    end
  end
end
