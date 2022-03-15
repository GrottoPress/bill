module Bill::Api::CreditNotes::Show
  macro included
    # get "/credit-notes/:credit_note_id" do
    #   json CreditNoteSerializer.new(credit_note: credit_note)
    # end

    getter credit_note : CreditNote do
      CreditNoteQuery.new.preload_line_items.find(credit_note_id)
    end
  end
end
