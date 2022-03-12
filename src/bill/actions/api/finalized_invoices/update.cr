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
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    getter invoice : Invoice do
      InvoiceQuery.new.preload_line_items.find(invoice_id)
    end

    def do_run_operation_succeeded(operation, invoice)
      invoice = InvoiceQuery.preload_line_items(invoice)

      json ItemResponse.new(
        invoice: invoice,
        message: Rex.t(:"action.invoice.update.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureResponse.new(
        errors: operation.errors,
        message: Rex.t(:"action.invoice.update.failure")
      )
    end
  end
end
