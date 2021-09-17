module Bill::Api::CreditNotesStatus::Update
  macro included
    # patch "/credit-notes/:credit_note_id/status" do
    #   run_operation
    # end

    def run_operation
      UpdateCreditNoteStatus.update(
        credit_note,
        params
      ) do |operation, updated_credit_note|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_credit_note)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    getter credit_note : CreditNote do
      CreditNoteQuery.new.preload_line_items.find(credit_note_id)
    end

    def do_run_operation_succeeded(operation, credit_note)
      credit_note = CreditNoteQuery.preload_line_items(credit_note)

      json({
        status: "success",
        message: "Credit note status updated successfully",
        data: {credit_note: CreditNoteSerializer.new(credit_note)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not update credit note status",
        data: {errors: operation.errors}
      })
    end
  end
end
