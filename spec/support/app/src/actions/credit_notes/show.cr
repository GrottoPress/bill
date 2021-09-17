class CreditNotes::Show < BrowserAction
  include Bill::CreditNotes::Show

  get "/credit-notes/:credit_note_id" do
    html ShowPage, credit_note: credit_note
  end
end
