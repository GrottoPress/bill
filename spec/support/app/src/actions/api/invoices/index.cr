class Api::Invoices::Index < ApiAction
  include Bill::Api::Invoices::Index

  param page : Int32 = 1

  get "/invoices" do
    json ListResponse.new(invoices: invoices, pages: pages)
  end
end
