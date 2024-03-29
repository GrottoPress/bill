module Bill::CreditNoteItems::Delete
  macro included
    include Bill::CreditNoteItems::Destroy

    # delete "/credit-notes/line-items/:credit_note_item_id" do
    #   run_operation
    # end

    def run_operation
      DeleteCreditNoteItem.delete(
        credit_note_item
      ) do |operation, deleted_credit_note_item|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_credit_note_item)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
