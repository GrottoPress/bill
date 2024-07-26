module Bill::ValidateReceipt
  macro included
    skip_default_validations

    before_save do
      validate_amount_required
      validate_business_details_required
      validate_description_required
      validate_status_required
      validate_user_details_required
      validate_user_id_required
      validate_amount_gt_zero
    end

    include Bill::ValidateStatusTransition
    include Bill::ValidateReference
    include Bill::ValidateDescription
    include Bill::ValidateNotes
    include Lucille::ValidateUserExists

    private def validate_amount_required
      validate_required amount,
        message: Rex.t(:"operation.error.amount_required")
    end

    private def validate_business_details_required
      validate_required business_details,
        message: Rex.t(:"operation.error.business_details_required")
    end

    private def validate_description_required
      validate_required description,
        message: Rex.t(:"operation.error.description_required")
    end

    private def validate_status_required
      validate_required status,
        message: Rex.t(:"operation.error.status_required")
    end

    private def validate_user_details_required
      validate_required user_details,
        message: Rex.t(:"operation.error.user_details_required")
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end

    private def validate_amount_gt_zero
      amount.value.try do |value|
        return if value > 0

        amount.add_error Rex.t(
          :"operation.error.amount_lte_zero",
          amount: value
        )
      end
    end
  end
end
