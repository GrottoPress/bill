module Bill
  Habitat.create do
    setting business_name : String
    setting business_address : String
    setting currency : ::Currency
    setting max_debt_allowed : Int32 = 0

    setting credit_note_reference : CreditNote -> String =
      ->(credit_note : Bill::CreditNote) do
        credit_note.id.to_s.rjust(3, '0')
      end

    setting invoice_reference : Invoice -> String =
      ->(invoice : Bill::Invoice) do
        invoice.id.to_s.rjust(3, '0')
      end

    setting receipt_reference : Receipt -> String =
      ->(receipt : Bill::Receipt) do
        receipt.id.to_s.rjust(3, '0')
      end
  end
end
