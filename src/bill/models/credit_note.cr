module Bill::CreditNote
  macro included
    include Bill::BelongsToInvoice

    column description : String
    column notes : String?
    column reference : String?
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

    def amount : Int32
      0
    end

    def amount! : Int32
      0
    end

    def amount_fm
      FractionalMoney.new(amount)
    end

    def amount_fm!
      FractionalMoney.new(amount!)
    end
  end
end
