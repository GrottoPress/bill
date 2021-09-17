require "../../../spec_helper"

describe Bill::CreditNotes::Index do
  it "lists credit notes" do
    response = ApiClient.exec(CreditNotes::Index)

    response.body.should eq("CreditNotes::IndexPage")
  end
end
