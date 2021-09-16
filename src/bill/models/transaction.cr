module Bill::Transaction
  macro included
    include Bill::BelongsToUser

    column amount : Int32
    column description : String
    column metadata : JSON::Any?
    column type : TransactionType

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
