module Bill::TransactionQuery
  macro included
    def is_debit
      amount.gt(0)
    end

    def is_not_debit
      amount.not.gt(0)
    end

    def is_credit
      amount.lt(0)
    end

    def is_not_credit
      amount.not.lt(0)
    end

    def is_zero
      amount(0)
    end

    def is_not_zero
      amount.not.eq(0)
    end
  end
end
