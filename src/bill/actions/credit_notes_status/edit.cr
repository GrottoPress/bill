module Bill::CreditNotesStatus::Edit
  macro included
    # get "/credit-notes/:credit_note_id/status/edit" do
    #   operation = UpdateCreditNoteStatus.new(credit_note)
    #   html EditPage, operation: operation
    # end

    getter credit_note : CreditNote do
      CreditNoteQuery.find(credit_note_id)
    end
  end
end
