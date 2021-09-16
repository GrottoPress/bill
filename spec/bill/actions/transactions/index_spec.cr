require "../../../spec_helper"

describe Bill::Transactions::Index do
  it "lists transactions" do
    response = ApiClient.exec(Transactions::Index)

    response.body.should eq("Transactions::IndexPage")
  end
end
