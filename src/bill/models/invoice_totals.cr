module Bill::InvoiceTotals
  macro included
    include JSON::Serializable

    property credit_notes : Int32 = 0
    property line_items : Int32 = 0
  end
end
