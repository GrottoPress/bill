{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("CreditNoteItem")
%}

class CreditNote < BaseModel
  include Bill::HasManyCreditNoteItems
end

class CreditNoteItemQuery < CreditNoteItem::BaseQuery
  include Bill::CreditNoteItemQuery
end

class CreateCreditNote < CreditNote::SaveOperation
  include Bill::CreateCreditNoteLineItems
end

class UpdateCreditNote < CreditNote::SaveOperation
  include Bill::UpdateCreditNoteLineItems
end

class UpdateCreditNoteStatus < CreditNote::SaveOperation
  include Bill::ValidateHasLineItems
end

class CreateCreditNoteItem < CreditNoteItem::SaveOperation
  include Bill::CreateCreditNoteItem
end

class CreateCreditNoteItemForParent < CreditNoteItem::SaveOperation
  include Bill::CreateCreditNoteItemForParent
end

class UpdateCreditNoteItem < CreditNoteItem::SaveOperation
  include Bill::UpdateCreditNoteItem
end

class UpdateCreditNoteItemForParent < CreditNoteItem::SaveOperation
  include Bill::UpdateCreditNoteItemForParent
end

class DeleteCreditNoteItem < CreditNoteItem::DeleteOperation
  include Bill::DeleteCreditNoteItem
end

class DeleteCreditNoteItemForParent < CreditNoteItem::DeleteOperation
  include Bill::DeleteCreditNoteItemForParent
end
