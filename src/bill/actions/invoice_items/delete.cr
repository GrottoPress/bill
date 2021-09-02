module Bill::InvoiceItems::Delete
  macro included
    include Bill::InvoiceItems::Destroy

    # delete "/invoices/line-items/:invoice_item_id" do
    #   run_operation
    # end

    def run_operation
      DeleteInvoiceItem.delete(
        invoice_item
      ) do |operation, deleted_invoice_item|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_invoice_item.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
