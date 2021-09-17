module Bill::OptionalBelongsToCreditNote
  macro included
    belongs_to invoice : CreditNote?
  end
end
