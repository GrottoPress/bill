{% skip_file unless Avram::Model.all_subclasses.find(&.name.== :Invoice.id) %}

require "./common"

include Bill::InvoiceStatus

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

{% if Avram::Model.all_subclasses.find(&.name.== :CreditNote.id) %}
  class UpdateInvoiceTotalCreditNotes < Invoice::SaveOperation
    include Bill::UpdateInvoiceTotalCreditNotes
  end
{% end %}

{% if Avram::Model.all_subclasses.find(&.name.== :Receipt.id) %}
  class CreateSalesReceipt < Invoice::SaveOperation
    include Bill::CreateSalesReceipt
  end

  class UpdateSalesReceipt < Invoice::SaveOperation
    include Bill::UpdateSalesReceipt
  end
{% elsif Avram::Model.all_subclasses.find(&.name.== :Transaction.id) %}
  class CreateDirectSalesReceipt < Invoice::SaveOperation
    include Bill::CreateDirectSalesReceipt
  end

  class UpdateDirectSalesReceipt < Invoice::SaveOperation
    include Bill::UpdateDirectSalesReceipt
  end
{% end %}
