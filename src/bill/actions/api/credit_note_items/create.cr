module Bill::Api::CreditNoteItems::Create
  macro included
    # post "/credit-notes/:credit_note_id/line-items" do
    #   run_operation
    # end

    def run_operation
      CreateCreditNoteItem.create(
        params,
        credit_note_id: credit_note_id.to_i64
      ) do |operation, credit_note_item|
        if operation.saved?
          do_run_operation_succeeded(operation, credit_note_item.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, credit_note_item)
      credit_note = CreditNoteQuery.new
        .preload_line_items
        .find(credit_note_item.credit_note_id)

      json({
        status: "success",
        message: Rex.t(:"action.credit_note_item.create.success"),
        data: {credit_note: CreditNoteSerializer.new(credit_note)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.credit_note_item.create.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
