module Bill::Api::InvoiceItems::Update
  macro included
    # patch "/invoices/line-items/:invoice_item_id" do
    #   run_operation
    # end

    def run_operation
      UpdateInvoiceItem.update(
        invoice_item,
        params
      ) do |operation, updated_invoice_item|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_invoice_item)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    getter invoice_item : InvoiceItem do
      InvoiceItemQuery.new.preload_invoice.find(invoice_item_id)
    end

    def do_run_operation_succeeded(operation, invoice_item)
      invoice = InvoiceQuery.new
        .preload_line_items
        .find(invoice_item.invoice_id)

      json InvoiceSerializer.new(
        invoice: invoice,
        message: Rex.t(:"action.invoice_item.update.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.invoice_item.update.failure")
      )
    end
  end
end
