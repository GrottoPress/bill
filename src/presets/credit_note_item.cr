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

class UpdateCreditNoteItem < CreditNoteItem::SaveOperation
  include Bill::UpdateCreditNoteItem
end

class DeleteCreditNoteItem < CreditNoteItem::DeleteOperation
  include Bill::DeleteCreditNoteItem
end
