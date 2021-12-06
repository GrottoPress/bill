require "../../../../spec_helper"

describe Bill::Api::Invoices::Create do
  it "creates invoice" do
    response = ApiClient.exec(
      Api::Invoices::Create,
      invoice: {
        user_id: UserFactory.create.id,
        description: "New invoice",
        due_at: 3.days.from_now
      },
      line_items: [{
        description: "Item 1",
        quantity: 2,
        price_mu: 0.12
      }]
    )

    InvoiceQuery.new.any?.should be_true
    InvoiceItemQuery.new.any?.should be_true

    response.should send_json(200, message: "action.invoice.create.success")
  end
end
