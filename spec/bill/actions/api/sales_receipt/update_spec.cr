require "../../../../spec_helper"

describe Bill::Api::SalesReceipts::Update do
  it "updates sales receipt" do
    user = UserFactory.create

    invoice = InvoiceFactory.create &.user_id(user.id)
      .description("New invoice")
      .status(:draft)

    InvoiceItemFactory.create &.invoice_id(invoice.id)

    ReceiptQuery.new.none?.should be_true

    response = ApiClient.exec(
      Api::SalesReceipts::Update.with(invoice_id: invoice.id),
      invoice: {status: :open}
    )

    response.should send_json(200, message: "action.invoice.update.success")

    invoice.reload.status.paid?.should be_true

    # ameba:disable Performance/AnyInsteadOfEmpty
    ReceiptQuery.new.is_finalized.any?.should be_true
  end
end
