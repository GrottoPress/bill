alias Amount = Int32
alias Quantity = Int16

Bill.configure do |settings|
  settings.business_name = "ACME Inc"
  settings.business_address = "123 Joe Boy Street, Antarctica."
  settings.currency = Currency.new("GHS", "GH₵")

  settings.credit_note_reference = ->(counter : Int64) do
    "CRD#{counter.to_s.rjust(3, '0')}"
  end

  settings.invoice_reference = ->(counter : Int64) do
    "INV#{counter.to_s.rjust(3, '0')}"
  end

  settings.receipt_reference = ->(counter : Int64) do
    "RCT#{counter.to_s.rjust(3, '0')}"
  end

  settings.transaction_reference = ->(counter : Int64) do
    "TRN#{counter.to_s.rjust(3, '0')}"
  end
end

Time::Location.local = Time::Location.load("America/Detroit")
