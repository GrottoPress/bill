module Bill::UpdateReference
  macro included
    before_save do
      set_reference
      validate_reference_unique
    end

    private def validate_reference_unique
      validate_uniqueness_of reference, message: Rex.t(
        :"operation.error.reference_exists",
        reference: reference.value
      )
    end

    private def set_reference
      record.try do |_record|
        return if _record.reference

        reference.value = Bill.settings
          .{{ T.name.split("::").last.underscore.id }}_reference
          .call(_record.counter)
      end
    end
  end
end
