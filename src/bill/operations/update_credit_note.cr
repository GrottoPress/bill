module Bill::UpdateCreditNote
  macro included
    permit_columns :invoice_id, :description, :notes

    include Bill::RevertStatus
    include Bill::ValidateCreditNote
    include Bill::ValidateNotFinalized
  end
end
