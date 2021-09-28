require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details

  include Bill::SendFinalizedInvoiceEmail
end

describe Bill::SendFinalizedInvoiceEmail do
  it "sends email for new invoices" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      description: "New Invoice",
      due_at: 2.days.from_now,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, invoice|
      invoice.should be_a(Invoice)

      invoice.try do |invoice|
        invoice = InvoiceQuery.preload_user(invoice)
        NewInvoiceEmail.new(operation, invoice).should be_delivered
      end
    end
  end

  it "sends email for existing invoices" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)

    SaveInvoice.update(invoice, params(
      description: "New Invoice",
      status: :open
    )) do |operation, updated_invoice|
      operation.saved?.should be_true

      updated_invoice = InvoiceQuery.preload_user(updated_invoice)
      NewInvoiceEmail.new(operation, updated_invoice).should be_delivered
    end
  end

  it "does not send email for unfinalized invoices" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)

    SaveInvoice.update(invoice, params(
      description: "New Invoice",
    )) do |operation, updated_invoice|
      operation.saved?.should be_true

      updated_invoice = InvoiceQuery.preload_user(updated_invoice)
      NewInvoiceEmail.new(operation, updated_invoice).should_not(be_delivered)
    end
  end

  it "does not send email for already finalized invoices" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    SaveInvoice.update(invoice, params(
      description: "Another invoice"
    )) do |operation, updated_invoice|
      operation.saved?.should be_true

      updated_invoice = InvoiceQuery.preload_user(updated_invoice)
      NewInvoiceEmail.new(operation, updated_invoice).should_not(be_delivered)
    end
  end
end
