require "../../../spec_helper"

describe Bill::DirectReceipts::New do
  it "renders new page" do
    response = ApiClient.exec(DirectReceipts::New)

    response.body.should eq("DirectReceipts::NewPage")
  end
end
