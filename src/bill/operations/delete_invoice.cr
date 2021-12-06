module Bill::DeleteInvoice
  macro included
    before_delete do
      validate_not_finalized
    end

    private def validate_not_finalized
      record.try do |invoice|
        return unless invoice.finalized?

        status.add_error Rex.t(
          :"operation.error.invoice_finalized",
          id: invoice.id,
          status: invoice.status.to_s
        )
      end
    end
  end
end
