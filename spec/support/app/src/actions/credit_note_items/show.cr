class CreditNoteItems::Show < BrowserAction
  include Bill::CreditNoteItems::Show

  get "/credit-notes/line-items/:credit_note_item_id" do
    html ShowPage, credit_note_item: credit_note_item
  end
end
