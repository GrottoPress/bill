module Bill::InvoiceQuery
  macro included
    def is_due(on time = Time.utc)
      time = time.to_local
      is_open.due_at.between(time.at_beginning_of_day, time.at_end_of_day)
    end

    def is_not_due(on time = Time.utc)
      time = time.to_local

      where(&.is_not_open.or &.due_at.not.between(
        time.at_beginning_of_day,
        time.at_end_of_day
      ))
    end

    def is_overdue(on time = Time.utc)
      is_open.due_at.lt(time.to_local.at_beginning_of_day)
    end

    def is_not_overdue(on time = Time.utc)
      where(&.is_not_open.or &.due_at.not.lt(time.to_local.at_beginning_of_day))
    end

    def is_underdue(on time = Time.utc)
      is_open.due_at.gt(time.to_local.at_end_of_day)
    end

    def is_not_underdue(on time = Time.utc)
      where(&.is_not_open.or &.due_at.not.gt(time.to_local.at_end_of_day))
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
