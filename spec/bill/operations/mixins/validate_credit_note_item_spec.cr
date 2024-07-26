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

      operation.credit_note_id
        .should have_error("operation.error.credit_note_id_required")
    end
  end

  it "requires existing credit note" do
    SaveCreditNoteItem.create(params(
      credit_note_id: 1_i64,
      description: "New credit note item",
      price: 1
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      operation.credit_note_id
        .should have_error("operation.error.credit_note_not_found")
    end
  end

  it "requires description" do
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

    SaveCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      price: 1
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      operation.description
        .should have_error("operation.error.description_required")
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

      operation.price.should have_error("operation.error.price_required")
    end
  end

  it "requires price to be greater than 0" do
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

    SaveCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      description: "New credit note item",
      price: 0
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      operation.price.should have_error("operation.error.price_lte_zero")
    end
  end

  it "requires quantity to be greater than 0" do
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

    SaveCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      description: "New credit note item",
      quantity: 0,
      price: 1
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      operation.quantity
        .should have_error("operation.error.quantity_lte_zero")
    end
  end

  it "ensures total credit would not exceed invoice amount" do
    invoice = CreateInvoice.create!(
      params(
        user_id: UserFactory.create.id,
        description: "New invoice",
        due_at: 3.days.from_now,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "2"
      }]
    )

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    SaveCreditNoteItem.create(params(
      credit_note_id: credit_note.id,
      description: "New credit note item",
      quantity: 2,
      price: 3
    )) do |operation, _|
      operation.saved?.should be_false

      operation.id.should have_error("operation.error.credit_exceeds_invoice")
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

      operation.id.should have_error("operation.error.credit_exceeds_invoice")
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

      operation.id.should have_error("operation.error.credit_exceeds_invoice")
    end

    SaveCreditNoteItem.update(credit_note_item, params(
      quantity: 1,
      price: 3
    )) do |operation, _|
      operation.saved?.should be_true

      operation.id.should_not have_error
    end
  end

  it "rejects long description" do
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

    SaveCreditNoteItem.create(params(
      description: "d" * 600,
      credit_note_id: credit_note.id,
      price: 1
    )) do |operation, credit_note_item|
      credit_note_item.should be_nil

      operation.description
        .should(have_error "operation.error.description_too_long")
    end
  end
end
