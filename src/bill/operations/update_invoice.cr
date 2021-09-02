module Bill::UpdateInvoice
  macro included
    permit_columns :user_id, :description, :due_at, :notes

    before_save do
      revert_status
      validate_not_finalized
    end

    include Bill::ValidateInvoice

    private def validate_not_finalized
      record.try do |invoice|
        id.add_error("is finalized") if invoice.finalized?
      end
    end

    private def revert_status
      status.value = status.original_value
    end
  end
end
