class CreditNotes::New < BrowserAction
  include Bill::CreditNotes::New

  get "/credit-notes/new" do
    operation = CreateCreditNote.new

    html NewPage, operation: operation
  end
end
