module Bill::CreditNoteItems::Update
  macro included
    # patch "/credit-notes/line-items/:credit_note_item_id" do
    #   run_operation
    # end

    def run_operation
      UpdateCreditNoteItem.update(
        credit_note_item,
        params
      ) do |operation, updated_credit_note_item|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_credit_note_item)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    getter credit_note_item : CreditNoteItem do
      CreditNoteItemQuery.new.preload_credit_note.find(credit_note_item_id)
    end

    def do_run_operation_succeeded(operation, credit_note_item)
      flash.success = "Credit note item updated successfully"

      redirect to: CreditNotes::Show.with(
        credit_note_id: credit_note_item.credit_note_id
      )
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not update credit note item"
      html EditPage, operation: operation
    end
  end
end
