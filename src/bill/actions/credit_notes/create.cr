module Bill::CreditNotes::Create
  macro included
    # post "/credit-notes" do
    #   run_operation
    # end

    def run_operation
      CreateCreditNote.create(
        params,
        line_items: params.many_nested?(:line_items)
      ) do |operation, credit_note|
        if credit_note
          do_run_operation_succeeded(operation, credit_note.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, credit_note)
      flash.success = "Credit note created successfully"
      redirect to: Show.with(credit_note_id: credit_note.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not create credit note"
      html NewPage, operation: operation
    end
  end
end
