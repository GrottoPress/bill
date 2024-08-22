require "../../../spec_helper"

describe Bill::DirectSalesReceipts::New do
  it "renders new page" do
    response = ApiClient.exec(DirectSalesReceipts::New)

    response.body.should eq("DirectSalesReceipts::NewPage")
  end
end
