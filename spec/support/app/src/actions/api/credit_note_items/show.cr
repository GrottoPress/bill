class Api::CreditNoteItems::Show < ApiAction
  include Bill::Api::CreditNoteItems::Show

  get "/credit-notes/line-items/:credit_note_item_id" do
    json({
      status: "success",
      data: {credit_note_item: CreditNoteItemSerializer.new(credit_note_item)}
    })
  end
end
