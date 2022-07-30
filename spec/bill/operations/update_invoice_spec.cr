require "../../spec_helper"

describe Bill::UpdateInvoice do
  it "updates invoice" do
    user = UserFactory.create

    invoice = InvoiceFactory.create &.id(2)
      .user_id(user.id)
      .description("New invoice")
      .due_at(2.days.from_now.to_utc)
      .notes("A note")

    InvoiceItemFactory.create &.invoice_id(invoice.id).price(9)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(6)

    new_user = UserFactory.create &.email("some@one.now")
    new_description = "Another invoice"
    new_due_at = 10.days.from_now.to_utc
    new_notes = "Another note"

    UpdateInvoice.update(
      invoice,
      params(
        user_id: new_user.id,
        description: new_description,
        due_at: new_due_at,
        notes: new_notes
      ),
      line_items: Array(Hash(String, String)).new
    ) do |operation, updated_invoice|
      operation.saved?.should be_true

      updated_invoice.user_id.should eq(new_user.id)
      updated_invoice.description.should eq(new_description)
      updated_invoice.due_at.should eq(new_due_at.at_beginning_of_second)
      updated_invoice.reference.should eq("INV002")
      updated_invoice.notes.should eq(new_notes)
    end
  end

  it "updates invoice with line items" do
    user = UserFactory.create

    invoice = InvoiceFactory.create &.user_id(user.id)
      .description("New invoice")
      .due_at(2.days.from_now.to_utc)
      .notes("A note")
      .status(:draft)

    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id).price(9)
    invoice_item_2 = InvoiceItemFactory.create &.invoice_id(invoice.id).price(6)

    new_user = UserFactory.create &.email("some@one.now")
    new_description = "Another invoice"
    new_due_at = 10.days.from_now.to_utc
    new_notes = "Another note"
    new_status = InvoiceStatus.new(:open)

    UpdateInvoice.update(
      InvoiceQuery.preload_line_items(invoice),
      params(
        user_id: new_user.id,
        description: new_description,
        due_at: new_due_at,
        notes: new_notes,
        status: new_status
      ),
      line_items: [
        {"id" => invoice_item.id.to_s, "price" => "12"},
        {"id" => invoice_item_2.id.to_s, "delete" => ""},
        {"description" => "Item 3", "quantity" => "2", "price" => "8"},
        {"description" => "Item 4", "quantity" => "2", "price" => "6"}
      ]
    ) do |operation, updated_invoice|
      operation.saved?.should be_true

      updated_invoice.user_id.should eq(new_user.id)
      updated_invoice.description.should eq(new_description)
      updated_invoice.due_at.should eq(new_due_at.at_beginning_of_second)
      updated_invoice.notes.should eq(new_notes)
      updated_invoice.status.should eq(new_status)

      invoice_items = updated_invoice.line_items!
      invoice_items.size.should eq(3)
      invoice_items[0].price.should eq(12)
    end
  end

  it "prevents modifying finalized invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    UpdateInvoice.update(
      invoice,
      params(description: "Another invoice"),
      line_items: Array(Hash(String, String)).new
    ) do |operation, _|
      operation.saved?.should be_false

      operation.status.should have_error("operation.error.invoice_finalized")
    end
  end
end
