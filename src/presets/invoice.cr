{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("Invoice")
%}

include Bill::InvoiceStatus

class User < BaseModel
  include Bill::HasManyInvoices
end

class InvoiceQuery < Invoice::BaseQuery
  include Bill::InvoiceQuery
end

class CreateInvoice < Invoice::SaveOperation
  include Bill::CreateInvoice
end

class UpdateInvoice < Invoice::SaveOperation
  include Bill::UpdateInvoice
end

class UpdateFinalizedInvoice < Invoice::SaveOperation
  include Bill::UpdateFinalizedInvoice
end

class UpdateInvoiceTotals < Invoice::SaveOperation
  include Bill::UpdateInvoiceTotals
end

class UpdateInvoiceReference < Invoice::SaveOperation
  include Bill::UpdateReference
end

class DeleteInvoice < Invoice::DeleteOperation
  include Bill::DeleteInvoice
end

struct InvoiceState
  include Bill::InvoiceState
end

struct InvoiceTotals
  include Bill::InvoiceTotals
end
