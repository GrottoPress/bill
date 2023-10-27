module Bill::SetFinalizedCreatedAt
  macro included
    before_save do
      set_finalized_created_at
    end

    private def set_finalized_created_at
      return if created_at.value.nil?
      created_at.value = Time.utc if {{ T }}Status.now_finalized?(status)
    end
  end
end
