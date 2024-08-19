module Bill::User
  abstract def billing_details : String

  macro included
    {% if Avram::Model.all_subclasses.find(&.name.== :CreditNote.id) %}
      include Bill::HasManyCreditNotesThroughInvoices
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Invoice.id) %}
      include Bill::HasManyInvoices
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Receipt.id) %}
      include Bill::HasManyReceipts
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Transaction.id) %}
      include Bill::HasManyTransactions

      {% if Avram::Model.all_subclasses.find(&.name.== :CreditNote.id) %}
        include Bill::CreditNotesAmount
      {% end %}

      {% if Avram::Model.all_subclasses.find(&.name.== :Invoice.id) %}
        include Bill::InvoicesAmount
      {% end %}

      {% if Avram::Model.all_subclasses.find(&.name.== :Receipt.id) %}
        include Bill::ReceiptsAmount
      {% end %}
    {% end %}
  end
end
