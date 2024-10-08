{% unless Avram::Model.all_subclasses.find(&.name.== :CreditNote.id) %}
  {% skip_file %}
{% end %}

require "./common"

include Bill::CreditNoteStatus

class CreditNoteQuery < CreditNote::BaseQuery
  include Bill::CreditNoteQuery
end

class CreateCreditNote < CreditNote::SaveOperation
  include Bill::CreateCreditNote
end

class UpdateCreditNote < CreditNote::SaveOperation
  include Bill::UpdateCreditNote
end

class UpdateFinalizedCreditNote < CreditNote::SaveOperation
  include Bill::UpdateFinalizedCreditNote
end

class UpdateCreditNoteTotals < CreditNote::SaveOperation
  include Bill::UpdateCreditNoteTotals
end

class UpdateCreditNoteReference < CreditNote::SaveOperation
  include Bill::UpdateReference
end

class DeleteCreditNote < CreditNote::DeleteOperation
  include Bill::DeleteCreditNote
end

struct CreditNoteState
  include Bill::CreditNoteState
end

struct CreditNoteTotals
  include Bill::CreditNoteTotals
end
