module Bill::UpdateFinalizedReceipt
  macro included
    permit_columns :description, :notes, :status

    include Bill::ValidateReceipt
    include Bill::ValidateFinalized
  end
end
