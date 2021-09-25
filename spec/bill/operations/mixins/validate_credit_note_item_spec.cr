require "../../../spec_helper"

private class SaveCreditNoteItem < CreditNoteItem::SaveOperation
  permit_columns :credit_note_id, :description, :quantity, :price

  include Bill::ValidateCreditNoteItem
end

describe Bill::ValidateCreditNoteItem do
  it "requires credit note id" do
    SaveCreditNoteItem.create(params(
      description: "New credit note item",
      price: 1
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      assert_invalid(operation.credit_note_id, " required")
    end
  end

  it "requires existing credit note" do
    SaveCreditNoteItem.create(params(
      credit_note_id: 1_i64,
      description: "New credit note item",
      price: 1
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      assert_invalid(operation.credit_note_id, "not exist")
    end
  end

  it "requires description" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    SaveCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      price: 1
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      assert_invalid(operation.description, " required")
    end
  end

  it "requires price" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    SaveCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      description: "New credit note item"
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      assert_invalid(operation.price, " required")
    end
  end

  it "requires price to be greater than 0" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    SaveCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      description: "New credit note item",
      price: 0
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      assert_invalid(operation.price, "greater than")
    end
  end

  it "requires quantity to be greater than 0" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    SaveCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      description: "New credit note item",
      quantity: 0,
      price: 1
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      assert_invalid(operation.quantity, "greater than")
    end
  end

  it "ensures total credit would not exceed invoice amount" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(2)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    SaveCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      description: "New credit note item",
      quantity: 2,
      price: 3
    )) do |operation, _|
      operation.saved?.should be_false

      assert_invalid(operation.id, "cannot exceed 4")
    end

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .quantity(1)
        .price(2)

    SaveCreditNoteItem.update(credit_note_item, params(
      quantity: 2,
      price: 3
    )) do |operation, _|
      operation.saved?.should be_false

      assert_invalid(operation.id, "cannot exceed 4")
    end

    CreditNoteFactory.create &.invoice_id(invoice.id)

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
      .quantity(1)
      .price(1)

    SaveCreditNoteItem.update(credit_note_item, params(
      quantity: 2,
      price: 2
    )) do |operation, _|
      operation.saved?.should be_false

      assert_invalid(operation.id, "cannot exceed 3")
    end
  end
end
