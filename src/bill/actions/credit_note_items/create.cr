module Bill::CreditNoteItems::Create
  macro included
    # post "/credit-notes/:credit_note_id/line-items" do
    #   run_operation
    # end

    def run_operation
      CreateCreditNoteItem.create(
        params,
        credit_note_id: credit_note_id.to_i64
      ) do |operation, credit_note_item|
        if credit_note_item
          do_run_operation_succeeded(operation, credit_note_item.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, credit_note_item)
      flash.success = "Credit note item created successfully"

      redirect to: CreditNotes::Show.with(
        credit_note_id: credit_note_item.credit_note_id
      )
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not create credit note item"
      html NewPage, operation: operation
    end
  end
end
