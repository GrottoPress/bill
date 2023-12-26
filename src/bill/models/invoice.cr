module Bill::Invoice
  macro included
    include Bill::BelongsToUser
    include Bill::ParentNetAmount
    include Bill::ReferenceColumns

    column business_details : String
    column description : String?
    column due_at : Time
    column notes : String?
    column status : InvoiceStatus
    column totals : InvoiceTotals?, serialize: true
    column user_details : String

    delegate :draft?, :open?, :paid?, :finalized?, to: status

    def due_on : Time
      due_at.to_local.at_beginning_of_day
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
  end
end
