class Receipts::Index < BrowserAction
  include Bill::Receipts::Index

  param page : Int32 = 1

  get "/receipts" do
    html IndexPage, receipts: receipts, pages: pages
  end
end
