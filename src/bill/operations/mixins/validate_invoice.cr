module Bill::ValidateInvoice
  macro included
    before_save do
      validate_description_required
      validate_due_at_required
      validate_status_required
      validate_user_id_required
      validate_user_exists
    end

    include Bill::ValidateStatusTransition

    private def validate_description_required
      validate_required description
    end

    private def validate_due_at_required
      validate_required due_at
    end

    private def validate_status_required
      validate_required status
    end

    private def validate_user_id_required
      validate_required user_id
    end

    private def validate_user_exists
      return unless user_id.changed?
      validate_primary_key(user_id, query: UserQuery)
    end
  end
end
