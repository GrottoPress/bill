require "../../../spec_helper"

describe Bill::FinalizeInvoiceTotals do
  it "updates totals" do
    CreateInvoice.create(
      params(
        user_id: UserFactory.create.id,
        description: "New invoice",
        due_at: 3.days.from_now,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "12"
      }]
    ) do |_, invoice|
      invoice.should be_a(Invoice)

      invoice.try do |invoice|
        invoice.reload.totals.try do |totals|
          totals.line_items.should eq(2 * 12)
        end
      end
    end
  end
end
