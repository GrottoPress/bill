require "../../../../spec_helper"

describe Bill::Api::Invoices::Index do
  it "lists invoices" do
    response = ApiClient.exec(Api::Invoices::Index)

    response.should send_json(200, data: {invoices: Array(JSON::Any).new})
  end
end
