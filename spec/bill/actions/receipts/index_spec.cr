require "../../../spec_helper"

describe Bill::Receipts::Index do
  it "lists receipts" do
    response = ApiClient.exec(Receipts::Index)

    response.body.should eq("Receipts::IndexPage")
  end
end
