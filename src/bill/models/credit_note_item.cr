module Bill::CreditNoteItem
  macro included
    # include Bill::BelongsToCreditNote

    column description : String
    column quantity : Quantity
    column price : Amount

    def price_fm
      FractionalMoney.new(price)
    end

    def amount : Amount
      Amount.new(price * quantity)
    end

    def amount_fm
      FractionalMoney.new(amount)
    end
  end
end
