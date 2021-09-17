module Bill::UpdateCreditNoteStatus
  macro included
    permit_columns :status

    include Bill::SetFinalizedCreatedAt
    include Bill::ValidateCreditNote
    include Bill::ValidateHasLineItems
  end
end
