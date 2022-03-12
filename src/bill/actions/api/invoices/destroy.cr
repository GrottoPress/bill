module Bill::Api::Invoices::Destroy
  macro included
    # delete "/invoices/:invoice_id" do
    #   run_operation
    # end

    # def run_operation
    #   DeactivateInvoice.update(invoice) do |operation, updated_invoice|
    #     if operation.saved?
    #       do_run_operation_succeeded(operation, updated_invoice)
    #     else
    #       response.status_code = 400
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter invoice : Invoice do
      InvoiceQuery.find(invoice_id)
    end

    def do_run_operation_succeeded(operation, invoice)
      invoice = InvoiceQuery.preload_line_items(invoice)

      json ItemResponse.new(
        invoice: invoice,
        message: Rex.t(:"action.invoice.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureResponse.new(
        errors: operation.errors,
        message: Rex.t(:"action.invoice.destroy.failure")
      )
    end
  end
end
