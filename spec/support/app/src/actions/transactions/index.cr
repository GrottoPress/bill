class Transactions::Index < BrowserAction
  include Bill::Transactions::Index

  param page : Int32 = 1

  get "/transactions" do
    html IndexPage, transactions: transactions, pages: pages
  end
end
