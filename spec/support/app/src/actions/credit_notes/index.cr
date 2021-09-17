class CreditNotes::Index < BrowserAction
  include Bill::CreditNotes::Index

  param page : Int32 = 1

  get "/credit-notes" do
    html IndexPage, credit_notes: credit_notes, pages: pages
  end
end
