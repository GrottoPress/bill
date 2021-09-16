require "../../../spec_helper"

describe Bill::DebitTransactions::New do
  it "renders new page" do
    response = ApiClient.exec(DebitTransactions::New)

    response.body.should eq("DebitTransactions::NewPage")
  end
end
