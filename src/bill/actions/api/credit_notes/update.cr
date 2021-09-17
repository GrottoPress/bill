module Bill::Api::CreditNotes::Update
  macro included
    # patch "/credit-notes/:credit_note_id" do
    #   run_operation
    # end

    def run_operation
      UpdateCreditNote.update(
        credit_note,
        params,
        line_items: params.many_nested?(:line_items)
      ) do |operation, updated_credit_note|
        if operation.saved?
          do_run_operation_succeeded(operation, reload(updated_credit_note))
        else
          do_run_operation_failed(operation)
        end
      end
    end

    getter credit_note : CreditNote do
      CreditNoteQuery.new.preload_line_items.find(credit_note_id)
    end

    def do_run_operation_succeeded(operation, credit_note)
      json({
        status: "success",
        message: "Credit note updated successfully",
        data: {credit_note: CreditNoteSerializer.new(credit_note)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not update credit note",
        data: {errors: operation.errors}
      })
    end

    private def reload(credit_note)
      CreditNoteQuery.preload_line_items(credit_note)
    end
  end
end
