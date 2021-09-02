module Bill::SetPriceFromMu
  macro included
    attribute price_mu : Float64

    before_save do
      set_price_from_mu
    end

    private def set_price_from_mu
      price_mu.value.try do |value|
        price.value = FractionalMoney.from_mu(value).amount
      end
    end
  end
end
