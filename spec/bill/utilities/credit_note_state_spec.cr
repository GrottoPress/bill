require "../../spec_helper"

describe Bill::CreditNoteState do
  describe "#transition" do
    it "allows valid transitions" do
      draft = CreditNoteStatus.new(:draft)
      open = CreditNoteStatus.new(:open)

      CreditNoteState.new(draft).transition(open)
        .should(eq CreditNoteState.new(open))
    end

    it "disallows invalid transitions" do
      draft = CreditNoteStatus.new(:draft)
      open = CreditNoteStatus.new(:open)

      CreditNoteState.new(open).transition(draft).should(be_nil)
    end
  end
end
