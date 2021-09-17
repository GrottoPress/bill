module Bill::CreditNoteItems::Show
  macro included
    # get "/credit-notes/line-items/:credit_note_item_id" do
    #   html ShowPage, credit_note_item: credit_note_item
    # end

    getter credit_note_item : CreditNoteItem do
      CreditNoteItemQuery.find(credit_note_item_id)
    end
  end
end
