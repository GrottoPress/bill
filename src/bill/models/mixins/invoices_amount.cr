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

    def soft_owes?
      Ledger.invoices.soft_owing?(self)
    end

    def soft_owes!
      Ledger.invoices.soft_owing!(self)
    end

    def hard_owes?
      Ledger.invoices.hard_owing?(self)
    end

    def hard_owes!
      Ledger.invoices.hard_owing!(self)
    end

    def over_owes?
      Ledger.invoices.over_owing?(self)
    end

    def over_owes!
      Ledger.invoices.over_owing!(self)
    end

    def over_soft_owes?
      Ledger.invoices.over_soft_owing?(self)
    end

    def over_soft_owes!
      Ledger.invoices.over_soft_owing!(self)
    end

    def over_hard_owes?
      Ledger.invoices.over_hard_owing?(self)
    end

    def over_hard_owes!
      Ledger.invoices.over_hard_owing!(self)
    end
  end
end
