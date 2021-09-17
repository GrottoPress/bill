module Bill::CreditNotesAmount
  macro included
    def credit_notes_amount
      -Ledger.credit_notes.balance(self)
    end

    def credit_notes_amount!
      -Ledger.credit_notes.balance!(self)
    end

    def credit_notes_amount_fm
      FractionalMoney.new(credit_notes_amount)
    end

    def credit_notes_amount_fm!
      FractionalMoney.new(credit_notes_amount!)
    end
  end
end
