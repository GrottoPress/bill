module Bill::SetDefaultStatus
  macro included
    before_save do
      set_default_status
    end

    private def set_default_status
      return unless status.value.nil?
      status.value = {{ T }}Status.new(:draft)
    end
  end
end
