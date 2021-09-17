require "../../../../spec_helper"

describe Bill::Api::CreditNotes::Index do
  it "lists credit notes" do
    response = ApiClient.exec(Api::CreditNotes::Index)

    response.should send_json(200, data: {credit_notes: Array(JSON::Any).new})
  end
end
