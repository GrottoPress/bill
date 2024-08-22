require "../../../spec_helper"

describe Bill::DirectSalesReceipts::Update do
  it "updates direct sales receipt" do
    user = UserFactory.create

    invoice = InvoiceFactory.create &.user_id(user.id)
      .description("New invoice")
      .status(:draft)

    InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(
      DirectSalesReceipts::Update.with(invoice_id: invoice.id),
      invoice: {status: :open}
    )

    response.status.should eq(HTTP::Status::FOUND)

    invoice.reload.status.paid?.should be_true

    TransactionQuery.new
      .user_id(user.id)
      .type(:receipt)
      .is_finalized
      .none?
      .should(be_false)
  end
end
