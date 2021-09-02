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
        if invoice_item
          do_run_operation_succeeded(operation, invoice_item.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, invoice_item)
      flash.success = "Invoice item created successfully"
      redirect to: Invoices::Show.with(invoice_id: invoice_item.invoice_id)
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not create invoice item"
      html NewPage, operation: operation
    end
  end
end
