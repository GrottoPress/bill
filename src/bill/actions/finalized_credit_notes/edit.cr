module Bill::FinalizedCreditNotes::Edit
  macro included
    # get "/credit-notes/:credit_note_id/finalized/edit" do
    #   operation = UpdateFinalizedCreditNote.new(
    #     credit_note,
    #     line_items: Array(Hash(String, String)).new
    #   )
    #
    #   html EditPage, operation: operation
    # end

    getter credit_note : CreditNote do
      CreditNoteQuery.new.preload_line_items.find(credit_note_id)
    end
  end
end
