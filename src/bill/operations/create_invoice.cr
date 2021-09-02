module Bill::CreateInvoice
  macro included
    permit_columns :user_id, :description, :due_at, :notes, :status

    before_save do
      set_default_status
    end

    include Bill::ValidateInvoice

    private def set_default_status
      return if status.value
      status.value = InvoiceStatus.new(:draft)
    end
  end
end
