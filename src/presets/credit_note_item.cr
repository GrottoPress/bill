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
  include Bill::FinalizeCreditNoteTotals
end

class UpdateCreditNote < CreditNote::SaveOperation
  include Bill::UpdateCreditNoteLineItems
  include Bill::FinalizeCreditNoteTotals
end

class UpdateFinalizedCreditNote < CreditNote::SaveOperation
  include Bill::UpdateFinalizedCreditNoteLineItems
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

class UpdateFinalizedCreditNoteItem < CreditNoteItem::SaveOperation
  include Bill::UpdateFinalizedCreditNoteItem
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
