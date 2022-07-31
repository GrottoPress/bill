Bill.configure do |settings|
  settings.business_name = "ACME Inc"
  settings.business_address = "123 Joe Boy Street, Antarctica."
  settings.currency = Currency.new("GHS", "GH₵")
  settings.max_debt_allowed = 400

  settings.credit_note_reference = ->(credit_note : Bill::CreditNote) do
    "CRD#{credit_note.id.to_s.rjust(3, '0')}"
  end

  settings.invoice_reference = ->(invoice : Bill::Invoice) do
    "INV#{invoice.id.to_s.rjust(3, '0')}"
  end

  settings.receipt_reference = ->(receipt : Bill::Receipt) do
    "RCT#{receipt.id.to_s.rjust(3, '0')}"
  end

  settings.transaction_reference = ->(transaction : Bill::Transaction) do
    "TRN#{transaction.id.to_s.rjust(3, '0')}"
  end
end
