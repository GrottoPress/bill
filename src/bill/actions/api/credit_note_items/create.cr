module Bill::Api::CreditNoteItems::Create
  macro included
    # post "/credit-notes/:credit_note_id/line-items" do
    #   run_operation
    # end

    def run_operation
      CreateCreditNoteItem.create(
        params,
        credit_note_id: _credit_note_id
      ) do |operation, credit_note_item|
        if operation.saved?
          do_run_operation_succeeded(operation, credit_note_item.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, credit_note_item)
      credit_note = CreditNoteQuery.new
        .preload_line_items
        .find(credit_note_item.credit_note_id)

      json CreditNoteSerializer.new(
        credit_note: credit_note,
        message: Rex.t(:"action.credit_note_item.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.credit_note_item.create.failure")
      )
    end

    private def _credit_note_id
      CreditNote::PrimaryKeyType.adapter.parse!(credit_note_id)
    end
  end
end
