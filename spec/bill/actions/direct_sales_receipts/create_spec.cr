require "../../../spec_helper"

describe Bill::DirectSalesReceipts::Create do
  it "creates direct sales receipt" do
    user = UserFactory.create

    response = ApiClient.exec(
      DirectSalesReceipts::Create,
      invoice: {
        user_id: user.id,
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

    TransactionQuery.new
      .user_id(user.id)
      .type(:receipt)
      .is_finalized
      .none?
      .should(be_false)
  end
end
