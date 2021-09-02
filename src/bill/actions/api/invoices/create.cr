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
        if invoice
          do_run_operation_succeeded(operation, reload(invoice.not_nil!))
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, invoice)
      json({
        status: "success",
        message: "Invoice created successfully",
        data: {invoice: InvoiceSerializer.new(invoice)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not create invoice",
        data: {errors: operation.errors}
      })
    end

    private def reload(invoice)
      InvoiceQuery.preload_line_items(invoice)
    end
  end
end
