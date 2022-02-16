require "../../../spec_helper"

describe Bill::Invoices::Create do
  it "creates invoice" do
    response = ApiClient.exec(
      Invoices::Create,
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

    # ameba:disable Performance/AnyInsteadOfEmpty
    InvoiceQuery.new.any?.should be_true

    # ameba:disable Performance/AnyInsteadOfEmpty
    InvoiceItemQuery.new.any?.should be_true

    response.status.should eq(HTTP::Status::FOUND)
  end
end
