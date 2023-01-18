module Bill::UpdateReference
  macro included
    before_save do
      set_reference
    end

    include Bill::ValidateReference

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
