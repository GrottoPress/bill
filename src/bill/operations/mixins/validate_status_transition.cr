module Bill::ValidateStatusTransition
  macro included
    before_save do
      validate_status_transition
    end

    private def validate_status_transition
      return unless status.changed?

      status.value.try do |value|
        status.original_value.try do |original_value|
          return if {{ T }}State.new(original_value).transition(value)

          status.add_error Rex.t(
            :"operation.error.status_transition_invalid",
            status: original_value,
            new_status: value
          )
        end
      end
    end
  end
end
