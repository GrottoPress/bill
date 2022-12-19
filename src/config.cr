module Bill
  Habitat.create do
    setting business_name : String
    setting business_address : String
    setting currency : ::Currency

    setting credit_note_reference : Int64 -> String = ->(counter : Int64) do
      counter.to_s.rjust(3, '0')
    end

    setting invoice_reference : Int64 -> String = ->(counter : Int64) do
      counter.to_s.rjust(3, '0')
    end

    setting receipt_reference : Int64 -> String = ->(counter : Int64) do
      counter.to_s.rjust(3, '0')
    end

    setting transaction_reference : Int64 -> String = ->(counter : Int64) do
      counter.to_s.rjust(3, '0')
    end
  end
end
