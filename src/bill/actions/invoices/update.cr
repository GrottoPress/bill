module Bill::Invoices::Update
  macro included
    # patch "/invoices/:invoice_id" do
    #   run_operation
    # end

    def run_operation
      UpdateInvoice.update(
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
      flash.success = Rex.t(:"action.invoice.update.success")
      redirect to: Show.with(invoice_id: invoice.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.invoice.update.failure")
      html EditPage, operation: operation
    end
  end
end
