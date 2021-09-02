class Invoices::Index < BrowserAction
  include Bill::Invoices::Index

  param page : Int32 = 1

  get "/invoices" do
    html IndexPage, invoices: invoices, pages: pages
  end
end
