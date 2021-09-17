class CreditNotes::Create < BrowserAction
  include Bill::CreditNotes::Create

  post "/credit-notes" do
    run_operation
  end
end
