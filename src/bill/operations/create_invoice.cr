module Bill::CreateInvoice # Invoice::SaveOperation
  macro included
    permit_columns :user_id, :description, :due_at, :notes, :status

    include Bill::SetDefaultStatus
    include Bill::EnsureDueAtGteCreatedAt
    include Bill::SetBusinessDetails
    include Bill::SetUserDetails
    include Bill::SetReference
    include Bill::ValidateInvoice
  end
end
