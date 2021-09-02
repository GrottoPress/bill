module Bill::CashAccount
  macro included
    getter :record

    protected def foreign_key
      "#{@record.class.name.underscore.split("::").last}_id"
    end

    protected def raise_if_start_gt_end(begin_at, end_at)
      return unless begin_at && end_at

      if begin_at > end_at
        raise Bill::Error.new("Start time cannot be later than end time")
      end
    end
  end
end
