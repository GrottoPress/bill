module Bill::Receipt
  macro included
    include Bill::ReferenceColumns

    #include Bill::BelongsToUser

    column amount : Amount
    column business_details : String
    column description : String
    column notes : String?
    column status : ReceiptStatus
    column user_details : String

    delegate :draft?, :open?, :finalized?, to: status

    def amount_fm
      FractionalMoney.new(amount)
    end
  end
end
