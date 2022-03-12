class Api::CreditNoteItems::Show < ApiAction
  include Bill::Api::CreditNoteItems::Show

  get "/credit-notes/line-items/:credit_note_item_id" do
    json ItemResponse.new(credit_note_item: credit_note_item)
  end
end
