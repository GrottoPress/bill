module Bill::InvoiceTotals
  macro included
    include Lucille::JSON

    getter credit_notes : Int32 = 0
    getter line_items : Int32 = 0
  end
end
