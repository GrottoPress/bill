module Bill::InvoiceItems::Update
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
          do_run_operation_failed(operation)
        end
      end
    end

    getter invoice_item : InvoiceItem do
      InvoiceItemQuery.new.preload_invoice.find(invoice_item_id)
    end

    def do_run_operation_succeeded(operation, invoice_item)
      flash.success = "Invoice item updated successfully"
      redirect to: Invoices::Show.with(invoice_id: invoice_item.invoice_id)
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not update invoice item"
      html EditPage, operation: operation
    end
  end
end
