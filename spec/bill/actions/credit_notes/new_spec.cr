require "../../../spec_helper"

describe Bill::CreditNotes::New do
  it "renders new credit note page" do
    response = ApiClient.exec(CreditNotes::New)

    response.body.should eq("CreditNotes::NewPage")
  end
end
