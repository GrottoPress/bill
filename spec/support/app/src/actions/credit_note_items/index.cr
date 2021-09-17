class CreditNoteItems::Index < BrowserAction
  include Bill::CreditNoteItems::Index

  param page : Int32 = 1

  get "/credit-notes/:credit_note_id/line-items" do
    html IndexPage, credit_note_items: credit_note_items, pages: pages
  end
end
