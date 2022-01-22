require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details

  include Bill::NeedsLineItems
  include Bill::ValidateHasLineItems
end

describe Bill::ValidateHasLineItems do
  it "requires new invoice has line items" do
    SaveInvoice.create(
      params(
        user_id: UserFactory.create.id,
        business_details: "ACME Inc",
        description: "New Invoice",
        due_at: 3.days.from_now,
        status: :open
      ),
      line_items: Array(Hash(String, String)).new
    ) do |operation, invoice|
      invoice.should be_nil

      operation.id.should have_error("operation.error.invoice_items_empty")
    end
  end

  it "requires existing invoice has line items" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)

    SaveInvoice.update(
      InvoiceQuery.preload_line_items(invoice),
      params(status: :open),
      line_items: Array(Hash(String, String)).new
    ) do |operation, _|
      operation.saved?.should be_false
      operation.id.should have_error("operation.error.invoice_items_empty")
    end
  end

  it "skips existing invoice with line items in database" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    SaveInvoice.update(
      InvoiceQuery.preload_line_items(invoice),
      params(status: :open),
      line_items: Array(Hash(String, String)).new
    ) do |operation, _|
      operation.saved?.should be_true
    end
  end

  it "skips unfinalized new invoice" do
    SaveInvoice.create(
      params(
        user_id: UserFactory.create.id,
        business_details: "ACME Inc",
        description: "New Invoice",
        due_at: 3.days.from_now,
        status: :draft,
        user_details: "Mary Smith"
      ),
      line_items: Array(Hash(String, String)).new
    ) do |operation, invoice|
      invoice.should be_a(Invoice)
    end
  end

  it "skips unfinalized existing invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)

    SaveInvoice.update(
      invoice,
      params(description: "Another Invoice"),
      line_items: Array(Hash(String, String)).new
    ) do |operation, _|
      operation.saved?.should be_true
    end
  end
end
