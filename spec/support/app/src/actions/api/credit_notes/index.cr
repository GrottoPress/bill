class Api::CreditNotes::Index < ApiAction
  include Bill::Api::CreditNotes::Index

  param page : Int32 = 1

  get "/credit-notes" do
    json({
      status: "success",
      data: {credit_notes: CreditNoteSerializer.for_collection(credit_notes)},
      pages: {
        current: page,
        total: pages.total
      }
    })
  end
end
