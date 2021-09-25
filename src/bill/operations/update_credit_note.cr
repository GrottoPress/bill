module Bill::UpdateCreditNote
  macro included
    permit_columns :invoice_id, :description, :notes, :status

    include Bill::SetFinalizedCreatedAt
    include Bill::ValidateCreditNote
    include Bill::ValidateNotFinalized
  end
end
