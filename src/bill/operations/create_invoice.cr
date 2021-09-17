module Bill::CreateInvoice
  macro included
    permit_columns :user_id, :description, :due_at, :notes, :status

    include Bill::SetDefaultStatus
    include Bill::ValidateInvoice
  end
end
