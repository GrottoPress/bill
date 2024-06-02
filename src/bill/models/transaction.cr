module Bill::Transaction
  macro included
    include Bill::BelongsToUser
    include Bill::ReferenceColumns

    column amount : Amount
    column description : String
    column source : String? # Polymorphic Invoice/Receipt/CreditNote ID
    column status : TransactionStatus
    column type : TransactionType

    delegate :draft?, :open?, :finalized?, to: status

    def amount_fm
      FractionalMoney.new(amount)
    end

    def debit? : Bool
      amount.debit?
    end

    def credit? : Bool
      amount.credit?
    end

    def zero? : Bool
      amount.zero?
    end
  end
end
