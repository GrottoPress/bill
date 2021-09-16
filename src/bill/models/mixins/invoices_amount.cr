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
  end
end
