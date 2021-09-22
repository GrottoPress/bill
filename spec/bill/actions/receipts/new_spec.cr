require "../../../spec_helper"

describe Bill::Receipts::New do
  it "renders new page" do
    response = ApiClient.exec(Receipts::New)

    response.body.should eq("Receipts::NewPage")
  end
end
