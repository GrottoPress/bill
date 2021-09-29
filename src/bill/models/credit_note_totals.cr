module Bill::CreditNoteTotals
  macro included
    include JSON::Serializable

    property line_items : Int32 = 0
  end
end
