module Bill::ValidateInvoice
  macro included
    include Bill::SetUserFromUserId

    before_save do
      validate_business_details_required
      validate_description_required
      validate_due_at_required
      validate_status_required
      validate_user_details_required
      validate_user_id_required
      validate_user_exists
    end

    include Bill::ValidateStatusTransition

    private def validate_business_details_required
      validate_required business_details,
        message: Rex.t(:"operation.error.business_details_required")
    end

    private def validate_description_required
      validate_required description,
        message: Rex.t(:"operation.error.description_required")
    end

    private def validate_due_at_required
      validate_required due_at,
        message: Rex.t(:"operation.error.due_at_required")
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

    private def validate_user_exists
      user_id.value.try do |value|
        return if @user

        user_id.add_error Rex.t(
          :"operation.error.user_not_found",
          user_id: value
        )
      end
    end
  end
end
