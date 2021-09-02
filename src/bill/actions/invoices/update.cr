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
          do_run_operation_failed(operation)
        end
      end
    end

    getter invoice : Invoice do
      InvoiceQuery.new.preload_line_items.find(invoice_id)
    end

    def do_run_operation_succeeded(operation, invoice)
      flash.success = "Invoice updated successfully"
      redirect to: Show.with(invoice_id: invoice.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not update invoice"
      html EditPage, operation: operation
    end
  end
end
