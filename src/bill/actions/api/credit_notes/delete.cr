module Bill::Api::CreditNotes::Delete
  macro included
    include Bill::Api::CreditNotes::Destroy

    # delete "/credit-notes/:credit_note_id" do
    #   run_operation
    # end

    def run_operation
      DeleteCreditNote.delete(credit_note) do |operation, deleted_credit_note|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_credit_note.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
