module Bill::HasManyTransactions
  macro included
    has_many transactions : Transaction

    def balance
      Ledger.balance(transactions)
    end

    def balance!
      Ledger.balance!(self)
    end
  end
end
