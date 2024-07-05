module Bill::CreateCreditNote # CreditNote::SaveOperation
  macro included
    permit_columns :invoice_id, :description, :notes, :status

    include Bill::SetDefaultStatus
    include Bill::SetReference
    include Bill::ValidateCreditNote
  end
end
