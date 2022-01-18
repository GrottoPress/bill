module Bill::Api::CreditNoteItems::Update
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
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    getter credit_note_item : CreditNoteItem do
      CreditNoteItemQuery.new.preload_credit_note.find(credit_note_item_id)
    end

    def do_run_operation_succeeded(operation, credit_note_item)
      credit_note = CreditNoteQuery.new
        .preload_line_items
        .find(credit_note_item.credit_note_id)

      json({
        status: "success",
        message: Rex.t(:"action.credit_note_item.update.success"),
        data: {credit_note: CreditNoteSerializer.new(credit_note)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.credit_note_item.update.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
