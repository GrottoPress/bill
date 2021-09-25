module Bill::DeleteCreditNoteItem
  macro included
    include Bill::ValidateParentRecord
  end
end
