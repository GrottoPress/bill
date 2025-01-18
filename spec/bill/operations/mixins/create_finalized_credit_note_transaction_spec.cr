require "../../../spec_helper"

describe Bill::CreateFinalizedCreditNoteTransaction do
  it "creates transaction for new credit note" do
    user = UserFactory.create

    invoice = CreateInvoice.create!(
      params(
        user_id: user.id,
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

    CreateCreditNote.create(
      params(
        invoice_id: invoice.id,
        description: "New credit note",
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "12"
      }]
    ) do |_, credit_note|
      credit_note.should be_a(CreditNote)
    end

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.user_id(user.id).any?.should be_true
  end

  it "creates transaction for existing credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    UpdateCreditNote.update(
      credit_note,
      params(status: :open),
      line_items: Array(Hash(String, String)).new
    ) do |operation, _|
      operation.saved?.should be_true
    end

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.user_id(user.id).any?.should be_true
  end

  it "does not create transaction for unfinalized credit notes" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:draft)
    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    UpdateCreditNote.update(
      credit_note,
      params(description: "Another credit note"),
      line_items: Array(Hash(String, String)).new
    ) do |operation, _|
      operation.saved?.should be_true
    end

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.user_id(user.id).any?.should be_false
  end

  it "does not create transaction for already finalized credit notes" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    UpdateFinalizedCreditNote.update(
      credit_note,
      params(description: "Another credit note"),
      line_items: Array(Hash(String, String)).new
    ) do |operation, _|
      operation.saved?.should be_true
    end

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.user_id(user.id).any?.should be_false
  end
end
