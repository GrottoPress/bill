module Bill::InvoicesAmount
  macro included
    def invoices_amount
      Ledger.invoices.balance(self)
    end

    def invoices_amount!
      Ledger.invoices.balance!(self)
    end

    def invoices_amount_fm
      FractionalMoney.new(invoices_amount)
    end

    def invoices_amount_fm!
      FractionalMoney.new(invoices_amount!)
    end

    def owes?
      Ledger.invoices.owing?(self)
    end

    def owes!
      Ledger.invoices.owing!(self)
    end

    def over_owes?
      Ledger.invoices.over_owing?(self)
    end

    def over_owes!
      Ledger.invoices.over_owing!(self)
    end
  end
end
