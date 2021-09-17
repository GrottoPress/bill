module Bill::RevertStatus
  macro included
    before_save do
      revert_status
    end

    private def revert_status
      status.value = status.original_value
    end
  end
end
