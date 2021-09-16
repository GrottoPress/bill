module Bill::EnsureCreatedAtNotPast
  macro included
    before_save do
      set_created_at
    end

    private def set_created_at
      created_at.value.try do |value|
        created_at.value = Time.utc if value < Time.utc
      end
    end
  end
end
