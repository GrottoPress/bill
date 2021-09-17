module Bill::ValidateStatusTransition
  macro included
    before_save do
      validate_status_transition
    end

    private def validate_status_transition
      return unless status.changed?
      return unless value = status.value

      status.original_value.try do |original_value|
        unless {{ T }}State.new(original_value).transition(value)
          status.add_error("change to '#{value}' not allowed")
        end
      end
    end
  end
end
