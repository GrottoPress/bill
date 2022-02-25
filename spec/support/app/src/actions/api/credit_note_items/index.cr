class Api::CreditNoteItems::Index < ApiAction
  include Bill::Api::CreditNoteItems::Index

  param page : Int32 = 1

  get "/credit-notes/:credit_note_id/line-items" do
    json({
      status: "success",
      data: {credit_note_items: CreditNoteItemSerializer.for_collection(
        credit_note_items
      )},
      pages: PaginationSerializer.new(pages)
    })
  end
end
