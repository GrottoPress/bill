module Bill::SetAmountSign
  macro included
    attribute credit : Bool

    before_save do
      set_default_credit
      set_amount_sign
    end

    private def set_amount_sign
      amount.value.try do |_amount|
        credit.value.try do |_credit|
          amount.value = _credit ? -_amount.abs : _amount.abs
        end
      end
    end

    private def set_default_credit
      record.try do |transaction|
        return unless credit.value.nil?
        credit.value = transaction.credit?
      end
    end
  end
end
