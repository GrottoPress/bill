require "../../../spec_helper"

describe Bill::SalesReceipts::Create do
  it "creates sales receipt" do
    response = ApiClient.exec(
      SalesReceipts::Create,
      invoice: {
        user_id: UserFactory.create.id,
        description: "New invoice",
        due_at: 3.days.from_now,
        status: :open
      },
      line_items: [{
        description: "Item 1",
        quantity: 2,
        price_mu: 0.12
      }]
    )

    response.status.should eq(HTTP::Status::FOUND)

    # ameba:disable Performance/AnyInsteadOfEmpty
    InvoiceQuery.new.is_paid.any?.should be_true

    # ameba:disable Performance/AnyInsteadOfEmpty
    ReceiptQuery.new.is_finalized.any?.should be_true
  end
end
