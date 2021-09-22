module Bill::ValidateReceipt
  macro included
    before_save do
      validate_amount_required
      validate_description_required
      validate_status_required
      validate_user_id_required
      validate_amount_gt_zero
      validate_user_exists
    end

    include Bill::ValidateStatusTransition

    private def validate_amount_required
      validate_required amount
    end

    private def validate_description_required
      validate_required description
    end

    private def validate_status_required
      validate_required status
    end

    private def validate_user_id_required
      validate_required user_id
    end

    private def validate_amount_gt_zero
      amount.value.try do |value|
        amount.add_error("must be greater than zero") if value <= 0
      end
    end

    private def validate_user_exists
      return unless user_id.changed?
      validate_primary_key(user_id, query: UserQuery)
    end
  end
end
