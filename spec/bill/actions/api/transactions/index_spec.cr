require "../../../../spec_helper"

describe Bill::Api::Transactions::Index do
  it "lists transactions" do
    response = ApiClient.exec(Api::Transactions::Index)

    response.should send_json(200, data: {transactions: Array(JSON::Any).new})
  end
end
