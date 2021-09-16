module Bill::SetAmountFromMu
  macro included
    attribute amount_mu : Float64

    before_save do
      set_amount_from_mu
    end

    private def set_amount_from_mu
      amount_mu.value.try do |value|
        amount.value = FractionalMoney.from_mu(value).amount
      end
    end
  end
end
