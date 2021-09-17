module Bill::BelongsToCreditNote
  macro included
    belongs_to credit_note : CreditNote
  end
end
