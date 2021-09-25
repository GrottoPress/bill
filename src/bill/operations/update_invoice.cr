module Bill::UpdateInvoice
  macro included
    permit_columns :user_id, :description, :due_at, :notes, :status

    include Bill::SetFinalizedCreatedAt
    include Bill::SetBusinessDetails
    include Bill::SetUserDetails
    include Bill::ValidateInvoice
    include Bill::ValidateNotFinalized
  end
end
