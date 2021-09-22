require "../../spec_helper"

describe Bill::DeleteReceipt do
  it "deletes receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id)

    DeleteReceipt.delete(receipt) do |operation, _|
      operation.deleted?.should be_true
    end

    ReceiptQuery.new.id(receipt.id).any?.should be_false
  end
end
