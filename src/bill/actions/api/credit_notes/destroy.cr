module Bill::Api::CreditNotes::Destroy
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
    #       response.status_code = 400
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter credit_note : CreditNote do
      CreditNoteQuery.find(credit_note_id)
    end

    def do_run_operation_succeeded(operation, credit_note)
      credit_note = CreditNoteQuery.preload_line_items(credit_note)

      json CreditNoteSerializer.new(
        credit_note: credit_note,
        message: Rex.t(:"action.credit_note.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.credit_note.destroy.failure")
      )
    end
  end
end
