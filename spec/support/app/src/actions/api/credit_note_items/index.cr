class Api::CreditNoteItems::Index < ApiAction
  include Bill::Api::CreditNoteItems::Index

  param page : Int32 = 1

  get "/credit-notes/:credit_note_id/line-items" do
    json CreditNoteItemSerializer.new(
      credit_note_items: credit_note_items,
      pages: pages
    )
  end
end
