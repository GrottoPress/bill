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
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter invoice : Invoice do
      InvoiceQuery.find(invoice_id)
    end

    def do_run_operation_succeeded(operation, invoice)
      invoice = InvoiceQuery.preload_line_items(invoice)

      json({
        status: "success",
        message: "Invoice deleted successfully",
        data: {invoice: InvoiceSerializer.new(invoice)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not delete invoice",
        data: {errors: operation.errors}
      })
    end
  end
end
