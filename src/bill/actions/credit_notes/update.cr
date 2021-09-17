module Bill::CreditNotes::Update
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
      flash.success = "Credit note updated successfully"
      redirect to: Show.with(credit_note_id: credit_note.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not update credit note"
      html EditPage, operation: operation
    end
  end
end
