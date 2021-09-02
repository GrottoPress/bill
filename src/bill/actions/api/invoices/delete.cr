module Bill::Api::Invoices::Delete
  macro included
    include Bill::Api::Invoices::Destroy

    # delete "/invoices/:invoice_id" do
    #   run_operation
    # end

    def run_operation
      DeleteInvoice.delete(invoice) do |operation, deleted_invoice|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_invoice.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
