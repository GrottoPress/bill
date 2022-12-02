require "../../spec_helper"

describe Bill::CreateInvoice do
  it "creates new invoice" do
    description = "New invoice"
    due_at = 3.days.from_now.to_utc
    notes = "A note"
    status = InvoiceStatus.new(:draft)

    user = UserFactory.create

    CreateInvoice.create(
      params(
        user_id: user.id,
        description: description,
        due_at: due_at,
        notes: notes,
        status: status
      ),
      counter: 34567,
      line_items: Array(Hash(String, String)).new
    ) do |_, invoice|
      invoice.should be_a(Invoice)

      # ameba:disable Lint/ShadowingOuterLocalVar
      invoice.try do |invoice|
        invoice.user_id.should eq(user.id)
        invoice.description.should eq(description)
        invoice.due_at.should eq(due_at.at_beginning_of_second)
        invoice.notes.should eq(notes)
        invoice.reference.should eq("INV34567")
        invoice.status.should eq(status)
      end
    end
  end

  it "creates new invoice with line items" do
    description = "New invoice"
    due_at = 3.days.from_now.to_utc
    notes = "A note"
    status = InvoiceStatus.new(:open)

    user = UserFactory.create

    CreateInvoice.create(
      params(
        user_id: user.id,
        description: description,
        due_at: due_at,
        notes: notes,
        status: status
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "12"
      }]
    ) do |_, invoice|
      invoice.should be_a(Invoice)

      # ameba:disable Lint/ShadowingOuterLocalVar
      invoice.try do |invoice|
        invoice.user_id.should eq(user.id)
        invoice.description.should eq(description)
        invoice.due_at.should eq(due_at.at_beginning_of_second)
        invoice.notes.should eq(notes)
        invoice.status.should eq(status)

        invoice.line_items!.size.should eq(1)
      end
    end
  end
end
