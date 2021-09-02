module Bill::DeleteInvoice
  macro included
    before_delete do
      validate_not_finalized
    end

    private def validate_not_finalized
      id.add_error("is finalized") if record.finalized?
    end
  end
end
