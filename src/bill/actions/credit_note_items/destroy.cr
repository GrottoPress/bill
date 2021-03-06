module Bill::CreditNoteItems::Destroy
  macro included
    # delete "/credit-notes/line-items/:credit_note_item_id" do
    #   run_operation
    # end

    # def run_operation
    #   DeactivateCreditNoteItem.update(
    #     credit_note_item
    #   ) do |operation, updated_credit_note_item|
    #     if operation.saved?
    #       do_run_operation_succeeded(operation, updated_credit_note_item)
    #     else
    #       response.status_code = 400
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter credit_note_item : CreditNoteItem do
      CreditNoteItemQuery.new.preload_credit_note.find(credit_note_item_id)
    end

    def do_run_operation_succeeded(operation, credit_note_item)
      flash.success = Rex.t(:"action.credit_note_item.destroy.success")

      redirect to: CreditNotes::Show.with(
        credit_note_id: credit_note_item.credit_note_id
      )
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.credit_note_item.destroy.failure")

      redirect_back fallback: Index.with(
        credit_note_id: credit_note_item.credit_note_id
      )
    end
  end
end
