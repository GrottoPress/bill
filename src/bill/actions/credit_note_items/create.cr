module Bill::CreditNoteItems::Create
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
      flash.success = Rex.t(:"action.credit_note_item.create.success")

      redirect to: CreditNotes::Show.with(
        credit_note_id: credit_note_item.credit_note_id
      )
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.credit_note_item.create.failure")
      html NewPage, operation: operation
    end

    private def _credit_note_id
      CreditNote::PrimaryKeyType.adapter.parse!(credit_note_id)
    end
  end
end
