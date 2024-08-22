require "../../spec_helper"

describe Bill::CreateSalesReceipt do
  it "creates sales receipt" do
    user = UserFactory.create

    invoice_2 = CreateInvoice.create!(
      params(
        user_id: user.id,
        description: "Another invoice",
        due_at: Time.utc,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "12"
      }]
    )

    ReceiptQuery.new.none?.should be_true

    CreateSalesReceipt.create(
      params(
        user_id: user.id,
        description: "New invoice",
        due_at: 2.days.from_now,
        status: :open
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
        invoice.status.paid?.should be_true
      end
    end

    invoice_2.reload.status.open?.should be_true

    # ameba:disable Performance/AnyInsteadOfEmpty
    ReceiptQuery.new.is_finalized.any?.should be_true
  end
end
