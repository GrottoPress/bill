require "../../../spec_helper"

describe Bill::Invoices::New do
  it "renders new invoice page" do
    response = ApiClient.exec(Invoices::New)

    response.body.should eq("Invoices::NewPage")
  end
end
