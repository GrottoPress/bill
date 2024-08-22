require "../../../spec_helper"

describe Bill::SalesReceipts::New do
  it "renders new page" do
    response = ApiClient.exec(SalesReceipts::New)

    response.body.should eq("SalesReceipts::NewPage")
  end
end
