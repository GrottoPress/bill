require "../../spec_helper"

describe Bill::CreateCreditNoteItem do
  it "creates new invoice item" do
    description = "New invoice item"
    quantity = 2

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(999)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    CreateCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      description: description,
      quantity: quantity,
      price_mu: 3.33
    )) do |_, credit_note_item|
      credit_note_item.should be_a(CreditNoteItem)

      credit_note_item.try do |credit_note_item|
        credit_note_item.credit_note_id.should eq(credit_note.id)
        credit_note_item.description.should eq(description)
        credit_note_item.quantity.should eq(quantity)
        credit_note_item.price.should eq(333)
      end
    end
  end
end
