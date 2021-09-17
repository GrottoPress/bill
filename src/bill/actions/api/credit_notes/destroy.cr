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
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter credit_note : CreditNote do
      CreditNoteQuery.find(credit_note_id)
    end

    def do_run_operation_succeeded(operation, credit_note)
      credit_note = CreditNoteQuery.preload_line_items(credit_note)

      json({
        status: "success",
        message: "Credit note deleted successfully",
        data: {credit_note: CreditNoteSerializer.new(credit_note)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not delete credit note",
        data: {errors: operation.errors}
      })
    end
  end
end
