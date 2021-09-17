class Api::CreditNotes::Show < ApiAction
  include Bill::Api::CreditNotes::Show

  get "/credit-notes/:credit_note_id" do
    json({
      status: "success",
      data: {credit_note: CreditNoteSerializer.new(credit_note)}
    })
  end
end
