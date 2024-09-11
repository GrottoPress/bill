module Bill::CreditNote
  macro included
    include Bill::ParentAmount
    include Bill::ReferenceColumns

    # include Bill::BelongsToInvoice
    # include Bill::HasManyCreditNoteItems

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
