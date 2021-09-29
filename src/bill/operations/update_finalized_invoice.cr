module Bill::UpdateFinalizedInvoice
  macro included
    permit_columns :description, :due_at, :notes, :status

    include Bill::EnsureDueAtGteCreatedAt
    include Bill::ValidateInvoice
    include Bill::ValidateFinalized
  end
end
