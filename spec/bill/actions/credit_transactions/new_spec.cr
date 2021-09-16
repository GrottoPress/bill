require "../../../spec_helper"

describe Bill::CreditTransactions::New do
  it "renders new page" do
    response = ApiClient.exec(CreditTransactions::New)

    response.body.should eq("CreditTransactions::NewPage")
  end
end
