module Bill::InvoiceQuery
  macro included
    def is_due
      is_open.due_at.between(
        Time.utc.at_beginning_of_day,
        Time.utc.at_end_of_day
      )
    end

    def is_not_due
      where(&.is_not_open.or &.due_at.not.between(
        Time.utc.at_beginning_of_day,
        Time.utc.at_end_of_day
      ))
    end

    def is_overdue
      is_open.due_at.lt(Time.utc.at_beginning_of_day)
    end

    def is_not_overdue
      where(&.is_not_open.or &.due_at.not.lt(Time.utc.at_beginning_of_day))
    end

    def is_underdue
      is_open.due_at.gt(Time.utc.at_end_of_day)
    end

    def is_not_underdue
      where(&.is_not_open.or &.due_at.not.gt(Time.utc.at_end_of_day))
    end

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

    def is_paid
      status(:paid)
    end

    def is_not_paid
      status.not.eq(:paid)
    end

    def is_finalized
      is_not_draft
    end

    def is_not_finalized
      is_draft
    end
  end
end
