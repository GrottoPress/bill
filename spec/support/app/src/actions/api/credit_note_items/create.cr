class Api::CreditNoteItems::Create < ApiAction
  include Bill::Api::CreditNoteItems::Create

  post "/credit-notes/:credit_note_id/line-items" do
    run_operation
  end
end
