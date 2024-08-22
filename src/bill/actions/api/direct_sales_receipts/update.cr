module Bill::Api::DirectSalesReceipts::Update
  macro included
    # patch "/invoices/:invoice_id" do
    #   run_operation
    # end

    def run_operation
      UpdateDirectSalesReceipt.update(
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
      json InvoiceSerializer.new(
        invoice: InvoiceQuery.preload_line_items(invoice),
        message: Rex.t(:"action.invoice.update.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.invoice.update.failure")
      )
    end
  end
end
