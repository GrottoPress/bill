module Bill::Api::InvoicesStatus::Update
  macro included
    # patch "/invoices/:invoice_id/status" do
    #   run_operation
    # end

    def run_operation
      UpdateInvoiceStatus.update(
        invoice,
        params
      ) do |operation, updated_invoice|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_invoice)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    getter invoice : Invoice do
      InvoiceQuery.new.preload_line_items.find(invoice_id)
    end

    def do_run_operation_succeeded(operation, invoice)
      invoice = InvoiceQuery.preload_line_items(invoice)

      json({
        status: "success",
        message: "Invoice status updated successfully",
        data: {invoice: InvoiceSerializer.new(invoice)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not update invoice status",
        data: {errors: operation.errors}
      })
    end
  end
end
