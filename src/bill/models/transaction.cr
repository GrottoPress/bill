module Bill::Transaction
  macro included
    include Bill::BelongsToUser
    include Bill::ReferenceColumns

    column amount : Amount
    column description : String
    column metadata : TransactionMetadata?, serialize: true
    column status : TransactionStatus
    column type : TransactionType

    delegate :draft?, :open?, :finalized?, to: status

    def amount_fm
      FractionalMoney.new(amount)
    end

    def debit? : Bool
      Ledger.debit?(amount)
    end

    def credit? : Bool
      Ledger.credit?(amount)
    end

    def zero? : Bool
      Ledger.zero?(amount)
    end
  end
end
