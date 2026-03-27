module Bill::User
  abstract def billing_details : String

  macro included
    # include Bill::HasManyCreditNotesThroughInvoices
    # include Bill::HasManyInvoices
    # include Bill::HasManyReceipts

    {% if Avram::Model.all_subclasses.any?(&.name.== :Transaction.id) %}
      {% if Avram::Model.all_subclasses.any?(&.name.== :CreditNote.id) %}
        include Bill::CreditNotesAmount
      {% end %}

      {% if Avram::Model.all_subclasses.any?(&.name.== :Invoice.id) %}
        include Bill::InvoicesAmount
      {% end %}

      {% if Avram::Model.all_subclasses.any?(&.name.== :Receipt.id) %}
        include Bill::ReceiptsAmount
      {% end %}
    {% end %}
  end
end
