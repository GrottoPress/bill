class CreditNotes::New < BrowserAction
  include Bill::CreditNotes::New

  get "/credit-notes/new" do
    operation = CreateCreditNote.new(
      line_items: Array(Hash(String, String)).new
    )

    html NewPage, operation: operation
  end
end
