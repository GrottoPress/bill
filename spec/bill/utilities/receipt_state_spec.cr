require "../../spec_helper"

describe Bill::ReceiptState do
  describe "#transition" do
    it "allows valid transitions" do
      draft = ReceiptStatus.new(:draft)
      open = ReceiptStatus.new(:open)

      ReceiptState.new(draft).transition(open).should(eq ReceiptState.new(open))
    end

    it "disallows invalid transitions" do
      draft = ReceiptStatus.new(:draft)
      open = ReceiptStatus.new(:open)

      ReceiptState.new(open).transition(draft).should(be_nil)
    end
  end
end
