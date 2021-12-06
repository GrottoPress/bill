module Bill::Invoices::Create
  macro included
    # post "/invoices" do
    #   run_operation
    # end

    def run_operation
      CreateInvoice.create(
        params,
        line_items: params.many_nested?(:line_items)
      ) do |operation, invoice|
        if invoice
          do_run_operation_succeeded(operation, invoice.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, invoice)
      flash.success = Rex.t(:"action.invoice.create.success")
      redirect to: Show.with(invoice_id: invoice.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.invoice.create.failure")
      html NewPage, operation: operation
    end
  end
end
