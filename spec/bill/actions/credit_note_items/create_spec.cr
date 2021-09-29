require "../../../spec_helper"

describe Bill::CreditNoteItems::Create do
  it "creates credit note item" do
    invoice = CreateInvoice.create!(
      params(
        user_id: UserFactory.create.id,
        description: "New invoice",
        due_at: 3.days.from_now,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "999"
      }]
    )

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(
      CreditNoteItems::Create.with(credit_note_id: credit_note.id), credit_note_item: {
        description: "New credit note item",
        quantity: 2,
        price_mu: 3.33
      }
    )

    CreditNoteItemQuery.new.any?.should be_true
    response.status.should eq(HTTP::Status::FOUND)
  end
end
