module Bill::CreditNote
  macro included
    include Bill::ParentAmount
    include Bill::ReferenceColumns

    {% if Avram::Model.all_subclasses.find(&.name.== :Invoice.id) %}
      include Bill::BelongsToInvoice
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :CreditNoteItem.id) %}
      include Bill::HasManyCreditNoteItems
    {% end %}

    column description : String?
    column notes : String?
    column status : CreditNoteStatus
    column totals : CreditNoteTotals?, serialize: true

    delegate :draft?, :open?, :finalized?, to: status

    def user_details
      invoice.user_details
    end

    def user_details!
      invoice!.user_details
    end

    def business_details
      invoice.business_details
    end

    def business_details!
      invoice!.business_details
    end
  end
end
