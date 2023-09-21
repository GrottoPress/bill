module Bill::CreditNoteTotals
  macro included
    include Lucille::JSON

    getter line_items : Amount = 0

    def line_items_fm : FractionalMoney
      FractionalMoney.new(line_items)
    end
  end
end
