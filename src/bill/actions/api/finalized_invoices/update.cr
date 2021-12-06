module Bill::Api::FinalizedInvoices::Update
  macro included
    # patch "/invoices/:invoice_id/finalized" do
    #   run_operation
    # end

    def run_operation
      UpdateFinalizedInvoice.update(
        invoice,
        params,
        line_items: params.many_nested?(:line_items)
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
        message: Rex.t(:"action.invoice.update.success"),
        data: {invoice: InvoiceSerializer.new(invoice)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.invoice.update.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
