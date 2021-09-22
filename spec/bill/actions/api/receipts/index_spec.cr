require "../../../../spec_helper"

describe Bill::Api::Receipts::Index do
  it "lists receipts" do
    response = ApiClient.exec(Api::Receipts::Index)

    response.should send_json(200, data: {receipts: Array(JSON::Any).new})
  end
end
