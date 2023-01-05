module Bill::CreditNoteTotals
  macro included
    include Lucille::JSON

    getter line_items : Int32 = 0

    def line_items_fm : FractionalMoney
      FractionalMoney.new(line_items)
    end
  end
end
