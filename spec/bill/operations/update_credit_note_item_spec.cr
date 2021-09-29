require "../../spec_helper"

describe Bill::UpdateCreditNoteItem do
  it "updates credit note item" do
    new_description = "Another credit note item"
    new_quantity = 2

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

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .description("New credit note item")
        .quantity(1)
        .price(222)

    UpdateCreditNoteItem.update(
      CreditNoteItemQuery.preload_credit_note(credit_note_item),
      params(
        description: new_description,
        quantity: new_quantity,
        price_mu: 3.33
      )
    ) do |operation, updated_credit_note_item|
      operation.saved?.should be_true

      updated_credit_note_item.description.should eq(new_description)
      updated_credit_note_item.quantity.should eq(new_quantity)
      updated_credit_note_item.price.should eq(333)
    end
  end
end
