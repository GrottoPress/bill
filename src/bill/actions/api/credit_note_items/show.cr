module Bill::Api::CreditNoteItems::Show
  macro included
    # get "/credit-notes/line-items/:credit_note_item_id" do
    #   json ItemResponse.new(credit_note_item: credit_note_item)
    # end

    getter credit_note_item : CreditNoteItem do
      CreditNoteItemQuery.find(credit_note_item_id)
    end
  end
end
