module Bill::ValidateInvoice
  macro included
    before_save do
      validate_business_details_required
      validate_due_at_required
      validate_status_required
      validate_reference_unique
      validate_user_details_required
      validate_user_id_required
    end

    include Bill::ValidateStatusTransition
    include Lucille::ValidateUserExists

    private def validate_business_details_required
      validate_required business_details,
        message: Rex.t(:"operation.error.business_details_required")
    end

    private def validate_due_at_required
      validate_required due_at,
        message: Rex.t(:"operation.error.due_at_required")
    end

    private def validate_status_required
      validate_required status,
        message: Rex.t(:"operation.error.status_required")
    end

    private def validate_reference_unique
      validate_uniqueness_of reference, message: Rex.t(
        :"operation.error.reference_exists",
        reference: reference.value
      )
    end

    private def validate_user_details_required
      validate_required user_details,
        message: Rex.t(:"operation.error.user_details_required")
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end
  end
end
