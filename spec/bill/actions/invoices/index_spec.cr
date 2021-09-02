require "../../../spec_helper"

describe Bill::Invoices::Index do
  it "lists invoices" do
    response = ApiClient.exec(Invoices::Index)

    response.body.should eq("Invoices::IndexPage")
  end
end
