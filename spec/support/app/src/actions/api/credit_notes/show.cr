class Api::CreditNotes::Show < ApiAction
  include Bill::Api::CreditNotes::Show

  get "/credit-notes/:credit_note_id" do
    json ItemResponse.new(credit_note: credit_note)
  end
end
