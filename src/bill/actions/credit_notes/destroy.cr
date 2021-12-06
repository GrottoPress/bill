module Bill::CreditNotes::Destroy
  macro included
    # delete "/credit-notes/:credit_note_id" do
    #   run_operation
    # end

    # def run_operation
    #   DeactivateCreditNote.update(
    #     credit_note
    #   ) do |operation, updated_credit_note|
    #     if operation.saved?
    #       do_run_operation_succeeded(operation, updated_credit_note)
    #     else
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter credit_note : CreditNote do
      CreditNoteQuery.find(credit_note_id)
    end

    def do_run_operation_succeeded(operation, credit_note)
      flash.success = Rex.t(:"action.credit_note.destroy.success")
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.credit_note.destroy.failure")
      redirect_back fallback: Index
    end
  end
end
