module Bill::CreditNoteItems::Edit
  macro included
    # get "/credit-notes/line-items/:credit_note_item_id/edit" do
    #   operation = UpdateCreditNoteItem.new(credit_note_item)
    #   html EditPage, operation: operation
    # end

    getter credit_note_item : CreditNoteItem do
      CreditNoteItemQuery.find(credit_note_item_id)
    end
  end
end
