module Bill::SetFinalizedCreatedAt
  macro included
    before_save do
      set_finalized_created_at
    end

    private def set_finalized_created_at
      return unless created_at.value
      created_at.value = Time.utc if InvoiceStatus.now_finalized?(status)
    end
  end
end
