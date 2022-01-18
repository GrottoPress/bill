module Bill::Api::Invoices::Create
  macro included
    # post "/invoices" do
    #   run_operation
    # end

    def run_operation
      CreateInvoice.create(
        params,
        line_items: params.many_nested?(:line_items)
      ) do |operation, invoice|
        if operation.saved?
          do_run_operation_succeeded(operation, reload(invoice.not_nil!))
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, invoice)
      json({
        status: "success",
        message: Rex.t(:"action.invoice.create.success"),
        data: {invoice: InvoiceSerializer.new(invoice)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.invoice.create.failure"),
        data: {errors: operation.errors}
      })
    end

    private def reload(invoice)
      invoice = invoice.finalized? ? invoice.reload : invoice
      InvoiceQuery.preload_line_items(invoice)
    end
  end
end
