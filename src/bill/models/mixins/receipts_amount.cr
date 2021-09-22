module Bill::ReceiptsAmount
  macro included
    def receipts_amount
      -Ledger.receipts.balance(self)
    end

    def receipts_amount!
      -Ledger.receipts.balance!(self)
    end

    def receipts_amount_fm
      FractionalMoney.new(receipts_amount)
    end

    def receipts_amount_fm!
      FractionalMoney.new(receipts_amount!)
    end
  end
end
