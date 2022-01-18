module Bill::InvoiceItems::Create
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
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, invoice_item)
      flash.success = Rex.t(:"action.invoice_item.create.success")
      redirect to: Invoices::Show.with(invoice_id: invoice_item.invoice_id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.invoice_item.create.failure")
      html NewPage, operation: operation
    end
  end
end
