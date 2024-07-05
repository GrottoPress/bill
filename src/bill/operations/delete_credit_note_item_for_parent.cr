module Bill::DeleteCreditNoteItemForParent # CreditNoteItem::DeleteOperation
  macro included
    include Bill::ValidateParentOperation
  end
end
