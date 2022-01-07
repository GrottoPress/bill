module Bill::Api::InvoiceItems::Create
  macro included
    # post "/invoices/:invoice_id/line-items" do
    #   run_operation
    # end

    def run_operation
      CreateInvoiceItem.create(
        params,
        invoice_id: invoice_id.to_i64
      ) do |operation, invoice_item|
        if operation.saved?
          do_run_operation_succeeded(operation, invoice_item.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, invoice_item)
      invoice = InvoiceQuery.new
        .preload_line_items
        .find(invoice_item.invoice_id)

      json({
        status: "success",
        message: Rex.t(:"action.invoice_item.create.success"),
        data: {invoice: InvoiceSerializer.new(invoice)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.invoice_item.create.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
