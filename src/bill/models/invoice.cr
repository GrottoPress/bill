module Bill::Invoice
  macro included
    include Bill::BelongsToUser

    column description : String
    column due_at : Time
    column notes : String?
    column status : InvoiceStatus

    delegate :draft?, :open?, :paid?, :finalized?, to: status

    def due_on : Time
      due_at.at_beginning_of_day
    end

    def due? : Bool
     status.due?(self)
    end

    def overdue? : Bool
      status.overdue?(self)
    end

    def underdue? : Bool
      status.underdue?(self)
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
