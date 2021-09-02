module Bill::InvoiceItem
  macro included
    include Bill::BelongsToInvoice

    column description : String
    column quantity : Int16
    column price : Int32

    def price_fm
      FractionalMoney.new(price)
    end

    def amount : Int32
      price * quantity
    end

    def amount_fm
      FractionalMoney.new(amount)
    end
  end
end
