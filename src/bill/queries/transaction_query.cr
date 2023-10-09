module Bill::TransactionQuery
  macro included
    def is_draft
      status(:draft)
    end

    def is_not_draft
      status.not.eq(:draft)
    end

    def is_open
      status(:open)
    end

    def is_not_open
      status.not.eq(:open)
    end

    def is_finalized
      is_not_draft
    end

    def is_not_finalized
      is_draft
    end

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
