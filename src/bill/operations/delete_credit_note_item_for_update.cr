module Bill::DeleteCreditNoteItemForParent
  macro included
    include Bill::ValidateParentOperation
  end
end
