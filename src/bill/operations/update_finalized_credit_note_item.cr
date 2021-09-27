module Bill::UpdateFinalizedCreditNoteItem
  macro included
    permit_columns :description

    include Bill::ValidateCreditNoteItem
    include Bill::ValidateParentFinalized
  end
end
