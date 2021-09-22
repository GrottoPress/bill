module Bill::Receipt
  macro included
    include Bill::BelongsToUser

    column amount : Int32
    column description : String
    column notes : String?
    column status : ReceiptStatus

    delegate :draft?, :open?, :finalized?, to: status

    def amount_fm
      FractionalMoney.new(amount)
    end
  end
end
