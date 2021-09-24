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
      validate_required business_details
    end

    private def validate_description_required
      validate_required description
    end

    private def validate_due_at_required
      validate_required due_at
    end

    private def validate_status_required
      validate_required status
    end

    private def validate_user_details_required
      validate_required user_details
    end

    private def validate_user_id_required
      validate_required user_id
    end

    private def validate_user_exists
      user_id.add_error("does not exist") unless @user
    end
  end
end
