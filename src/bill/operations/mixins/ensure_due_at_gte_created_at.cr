module Bill::EnsureDueAtGteCreatedAt
  macro included
    before_save do
      ensure_due_at_gte_created_at
    end

    private def ensure_due_at_gte_created_at
      due_at.value.try do |value|
        min_date = created_at.value || 1.second.from_now.to_utc
        due_at.value = min_date if value < min_date
      end
    end
  end
end
