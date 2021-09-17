module Bill::CreditNotes::Edit
  macro included
    # get "/credit-notes/:credit_note_id/edit" do
    #   operation = UpdateCreditNote.new(
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
