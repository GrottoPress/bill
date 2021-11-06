module Bill::ValidateTransaction
  macro included
    before_save do
      validate_amount_required
      validate_description_required
      validate_type_required
      validate_user_id_required

      validate_not_update
      validate_amount_not_zero
      validate_user_exists
    end

    private def validate_user_id_required
      validate_required user_id
    end

    private def validate_description_required
      validate_required description
    end

    private def validate_amount_required
      validate_required amount
    end

    private def validate_type_required
      validate_required type
    end

    private def validate_not_update
      id.add_error("update is not allowed") if record
    end

    private def validate_amount_not_zero
      amount.value.try do |value|
        amount.add_error("cannot be zero") if value.zero?
      end
    end

    private def validate_user_exists
      return unless user_id.changed?
      validate_foreign_key(user_id, query: UserQuery)
    end
  end
end
