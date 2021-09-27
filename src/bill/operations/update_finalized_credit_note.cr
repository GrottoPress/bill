module Bill::UpdateFinalizedCreditNote
  macro included
    permit_columns :description, :notes, :status

    include Bill::ValidateCreditNote
    include Bill::ValidateFinalized
  end
end
