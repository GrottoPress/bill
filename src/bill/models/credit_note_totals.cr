module Bill::CreditNoteTotals
  macro included
    include Lucille::JSON

    getter line_items : Int32 = 0
  end
end
