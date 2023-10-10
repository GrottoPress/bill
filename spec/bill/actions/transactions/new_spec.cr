require "../../../spec_helper"

describe Bill::Transactions::New do
  it "renders new page" do
    response = ApiClient.exec(Transactions::New)

    response.body.should eq("Transactions::NewPage")
  end
end
