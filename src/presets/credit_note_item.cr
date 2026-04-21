{% unless Avram::Model.all_subclasses.any?(&.name.== :CreditNoteItem.id) %}
  {% skip_file %}
{% end %}

require "./common"

class CreditNoteItem::BaseQuery
  include Bill::CreditNoteItemQuery
end

class CreditNoteItemQuery < CreditNoteItem::BaseQuery
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
