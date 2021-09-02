module Bill::Api::InvoiceItems::Destroy
  macro included
    # delete "/invoices/line-items/:invoice_item_id" do
    #   run_operation
    # end

    # def run_operation
    #   DeactivateInvoiceItem.update(
    #     invoice_item
    #   ) do |operation, updated_invoice_item|
    #     if operation.saved?
    #       do_run_operation_succeeded(operation, updated_invoice_item)
    #     else
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter invoice_item : InvoiceItem do
      InvoiceItemQuery.new.preload_invoice.find(invoice_item_id)
    end

    def do_run_operation_succeeded(operation, invoice_item)
      invoice = InvoiceQuery.new
        .preload_line_items
        .find(invoice_item.invoice_id)

      json({
        status: "success",
        message: "Invoice item deleted successfully",
        data: {invoice: InvoiceSerializer.new(invoice)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not delete invoice item",
        data: {errors: operation.errors}
      })
    end
  end
end
