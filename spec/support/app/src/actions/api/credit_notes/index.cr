class Api::CreditNotes::Index < ApiAction
  include Bill::Api::CreditNotes::Index

  param page : Int32 = 1

  get "/credit-notes" do
    json CreditNoteSerializer.new(credit_notes: credit_notes, pages: pages)
  end
end
