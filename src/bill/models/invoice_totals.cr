module Bill::InvoiceTotals
  macro included
    include Lucille::JSON

    getter credit_notes : Int32 = 0
    getter line_items : Int32 = 0

    def credit_notes_fm : FractionalMoney
      FractionalMoney.new(credit_notes)
    end

    def line_items_fm : FractionalMoney
      FractionalMoney.new(line_items)
    end
  end
end
