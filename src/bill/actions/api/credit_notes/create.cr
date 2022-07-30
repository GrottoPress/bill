module Bill::Api::CreditNotes::Create
  macro included
    # post "/credit-notes" do
    #   run_operation
    # end

    def run_operation
      CreateCreditNote.create(
        params,
        line_items: params.many_nested?(:line_items)
      ) do |operation, credit_note|
        if operation.saved?
          do_run_operation_succeeded(operation, credit_note.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, credit_note)
      json CreditNoteSerializer.new(
        credit_note: CreditNoteQuery.preload_line_items(credit_note),
        message: Rex.t(:"action.credit_note.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.credit_note.create.failure")
      )
    end
  end
end
