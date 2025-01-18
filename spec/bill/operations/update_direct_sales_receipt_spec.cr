require "../../spec_helper"

describe Bill::UpdateDirectSalesReceipt do
  it "updates sales receipt" do
    user = UserFactory.create

    invoice = CreateInvoice.create!(
      params(
        user_id: user.id,
        description: "New invoice",
        due_at: 2.days.from_now,
        status: :draft
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "12"
      }]
    )

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

    TransactionQuery.new.type(:receipt).none?.should be_true

    UpdateDirectSalesReceipt.update(
      invoice,
      params(status: :open),
      line_items: Array(Hash(String, String)).new
    ) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.status.paid?.should be_true
    end

    invoice_2.reload.status.open?.should be_true

    TransactionQuery.new
      .user_id(user.id)
      .type(:receipt)
      .is_finalized
      .none?
      .should(be_false)
  end
end
