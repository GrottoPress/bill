module Bill::Api::InvoiceItems::Delete
  macro included
    include Bill::Api::InvoiceItems::Destroy

    # delete "/invoices/line-items/:invoice_item_id" do
    #   run_operation
    # end

    def run_operation
      DeleteInvoiceItem.delete(
        invoice_item
      ) do |operation, deleted_invoice_item|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_invoice_item)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
