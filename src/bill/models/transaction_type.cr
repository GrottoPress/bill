module Bill::TransactionType
  macro included
    __enum TransactionType do
      Invoice
      CreditNote
      Receipt
    end
  end
end
