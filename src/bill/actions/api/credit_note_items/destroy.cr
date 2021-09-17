module Bill::Api::CreditNoteItems::Destroy
  macro included
    # delete "/credit-notes/line-items/:credit_note_item_id" do
    #   run_operation
    # end

    # def run_operation
    #   DeactivateCreditNoteItem.update(
    #     credit_note_item
    #   ) do |operation, updated_credit_note_item|
    #     if operation.saved?
    #       do_run_operation_succeeded(operation, updated_credit_note_item)
    #     else
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter credit_note_item : CreditNoteItem do
      CreditNoteItemQuery.new.preload_credit_note.find(credit_note_item_id)
    end

    def do_run_operation_succeeded(operation, credit_note_item)
      credit_note = CreditNoteQuery.new
        .preload_line_items
        .find(credit_note_item.credit_note_id)

      json({
        status: "success",
        message: "Credit note item deleted successfully",
        data: {credit_note: CreditNoteSerializer.new(credit_note)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not delete credit note item",
        data: {errors: operation.errors}
      })
    end
  end
end
