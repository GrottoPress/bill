require "../../spec_helper"

describe Bill::InvoiceState do
  describe "#transition" do
    it "allows valid transitions" do
      draft = InvoiceStatus.new(:draft)
      open = InvoiceStatus.new(:open)

      InvoiceState.new(draft).transition(open).should(eq InvoiceState.new(open))
    end

    it "disallows invalid transitions" do
      draft = InvoiceStatus.new(:draft)
      open = InvoiceStatus.new(:open)
      paid = InvoiceStatus.new(:paid)

      InvoiceState.new(draft).transition(paid).should(be_nil)
      InvoiceState.new(open).transition(draft).should(be_nil)
      InvoiceState.new(open).transition(paid).should(be_nil)
      InvoiceState.new(paid).transition(draft).should(be_nil)
      InvoiceState.new(paid).transition(open).should(be_nil)
    end
  end
end
