module Bill::CreditNote
  macro included
    include Bill::BelongsToInvoice

    column description : String
    column notes : String?
    column status : CreditNoteStatus

    delegate :draft?, :open?, :finalized?, to: status

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
