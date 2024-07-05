module Bill::DeleteCreditNoteItem # CreditNoteItem::DeleteOperation
  macro included
    include Bill::ValidateParentRecord
  end
end
