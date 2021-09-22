module Bill::Receipts::Delete
  macro included
    include Bill::Receipts::Destroy

    # delete "/receipts/:receipt_id" do
    #   run_operation
    # end

    def run_operation
      DeleteReceipt.delete(receipt) do |operation, deleted_receipt|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_receipt.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
