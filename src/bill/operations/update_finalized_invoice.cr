module Bill::UpdateFinalizedInvoice
  macro included
    permit_columns :description, :due_at, :notes, :status

    before_save do
      validate_finalized
    end

    include Bill::EnsureDueAtGteCreatedAt
    include Bill::ValidateInvoice

    private def validate_finalized
      record.try do |invoice|
        return if invoice.finalized?

        status.add_error Rex.t(
          :"operation.error.invoice_not_finalized",
          id: invoice.id,
          status: invoice.status.to_s
        )
      end
    end
  end
end
