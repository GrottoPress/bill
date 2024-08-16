module Bill::SetFinalizedCreatedAt
  macro included
    before_save do
      set_finalized_created_at
    end

    private def set_finalized_created_at
      return if created_at.changed?
      return unless {{ T }}Status.now_finalized?(status)

      created_at.value = Time.utc
    end
  end
end
