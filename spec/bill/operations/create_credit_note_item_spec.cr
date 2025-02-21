require "../../spec_helper"

describe Bill::CreateCreditNoteItem do
  it "creates new credit note item" do
    description = "New invoice item"
    quantity = 2

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
      .status(:open)

    CreateCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      description: description,
      quantity: quantity,
      price_mu: 3.33
    )) do |_, credit_note_item|
      credit_note_item.should be_a(CreditNoteItem)

      # ameba:disable Lint/ShadowingOuterLocalVar
      credit_note_item.try do |credit_note_item|
        credit_note_item.credit_note_id.should eq(credit_note.id)
        credit_note_item.description.should eq(description)
        credit_note_item.quantity.should eq(quantity)
        credit_note_item.price.should eq(333)
      end
    end
  end
end
