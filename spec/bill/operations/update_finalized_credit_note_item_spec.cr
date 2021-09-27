require "../../spec_helper"

describe Bill::UpdateFinalizedCreditNoteItem do
  it "updates item for finalized credit note" do
    new_description = "Another credit note item"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(999)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .description("New credit note item")
        .quantity(1)
        .price(222)

    UpdateFinalizedCreditNoteItem.update(
      CreditNoteItemQuery.preload_credit_note(credit_note_item),
      params(
        description: new_description,
        quantity: 2,
        price_mu: 3.33
      )
    ) do |operation, updated_credit_note_item|
      operation.saved?.should be_true

      updated_credit_note_item.description.should eq(new_description)
      updated_credit_note_item.quantity.should eq(1)
      updated_credit_note_item.price.should eq(222)
    end
  end
end
