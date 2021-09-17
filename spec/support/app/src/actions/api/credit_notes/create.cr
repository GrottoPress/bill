class Api::CreditNotes::Create < ApiAction
  include Bill::Api::CreditNotes::Create

  post "/credit-notes" do
    run_operation
  end
end
