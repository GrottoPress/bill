require "../../../spec_helper"

describe Bill::InvoicesLedger do
  describe "#balance" do
    it "returns correct balance" do
      user = UserFactory.create

      TransactionFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .type(:invoice)
        .status(:open)
        .amount(11)

      TransactionFactory.create &.user_id(user.id)
        .type(:invoice)
        .status(:draft)
        .amount(49)

      TransactionFactory.create &.user_id(user.id)
        .type(:receipt)
        .status(:open)
        .amount(-12)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      TransactionFactory.create &.user_id(user_2.id)
        .type(:invoice)
        .status(:open)
        .amount(-21)

      TransactionFactory.create &.user_id(user_2.id)
        .created_at(3.days.from_now)
        .type(:invoice)
        .status(:open)
        .amount(22)

      user = UserQuery.preload_transactions(user)
      user_2 = UserQuery.preload_transactions(user_2)

      ledger = Ledger.invoices
      transactions = user.transactions + user_2.transactions

      ledger.balance(transactions).should eq(11 - 21 + 22)
      ledger.balance(transactions, from: 1.day.ago).should eq(22 - 21)
      ledger.balance(transactions, till: 1.day.ago).should eq(11)
      ledger.balance(transactions, from: 1.day.ago, till: 1.day.from_now)
        .should eq(-21)

      ledger.balance!.should eq(11 - 21 + 22)
      ledger.balance!(from: 1.day.ago).should eq(22 - 21)
      ledger.balance!(till: 1.day.ago).should eq(11)
      ledger.balance!(from: 1.day.ago, till: 1.day.from_now).should eq(-21)

      user.invoices_amount.should eq(11)
      ledger.balance(user, from: 1.day.ago).should eq(0)
      ledger.balance(user, till: 1.day.ago).should eq(11)
      ledger.balance(user, from: 1.day.ago, till: 1.day.from_now).should eq(0)

      user.invoices_amount!.should eq(11)
      ledger.balance!(user, from: 1.day.ago).should eq(0)
      ledger.balance!(user, till: 1.day.ago).should eq(11)
      ledger.balance!(user, from: 1.day.ago, till: 1.day.from_now).should eq(0)

      user_2.invoices_amount.should eq(22 - 21)
      ledger.balance(user_2, from: 1.day.ago).should eq(22 - 21)
      ledger.balance(user_2, till: 1.day.ago).should eq(0)
      ledger.balance(user_2, from: 1.day.ago, till: 1.day.from_now)
        .should(eq -21)

      user_2.invoices_amount!.should eq(22 - 21)
      ledger.balance!(user_2, from: 1.day.ago).should eq(22 - 21)
      ledger.balance!(user_2, till: 1.day.ago).should eq(0)
      ledger.balance!(user_2, from: 1.day.ago, till: 1.day.from_now)
        .should(eq -21)
    end
  end

  describe "#owing?" do
    it "returns amount owing" do
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
          "price" => "500"
        }]
      )

      CreateReceipt.create(params(
        user_id: user.id,
        description: "New receipt",
        amount: 200,
        status: :open
      )) do |_, receipt|
        receipt.should be_a(Receipt)
      end

      user = UserQuery.preload_transactions(user)
      user = UserQuery.preload_invoices(user)

      user.owes?.should eq(500 * 1 - 200)
      user.owes!.should eq(500 * 1 - 200)

      user.over_owes?.should be_nil
      user.over_owes!.should be_nil

      CreateCreditNote.create(
        params(
          invoice_id: invoice.id,
          description: "New credit note",
          status: :open
        ),
        line_items: [{
          "description" => "Item 1",
          "quantity" => "1",
          "price" => "100"
        }]
      ) do |_, credit_note|
        credit_note.should be_a(CreditNote)
      end

      user = UserQuery.preload_transactions(user, force: true)
      user = UserQuery.preload_invoices(user, force: true)

      user.owes?.should eq(500 * 1 - 200 - 100 * 1)
      user.owes!.should eq(500 * 1 - 200 - 100 * 1)

      user.over_owes?.should be_nil
      user.over_owes!.should be_nil

      CreateInvoice.create(
        params(
          user_id: user.id,
          description: "New invoice",
          due_at: 2.days.ago,
          status: :open
        ),
        created_at: 3.days.ago,
        line_items: [{
          "description" => "Item 1",
          "quantity" => "1",
          "price" => "700"
        }]
      ) do |_, _invoice|
        _invoice.should be_a(Invoice)
      end

      user = UserQuery.preload_transactions(user, force: true)
      user = UserQuery.preload_invoices(user, force: true)

      user.owes?.should eq(500 * 1 - 200 - 100 * 1 + 700 * 1)
      user.owes!.should eq(500 * 1 - 200 - 100 * 1 + 700 * 1)

      user.over_owes?.should eq(700 * 1 - 200)
      user.over_owes!.should eq(700 * 1 - 200)
    end
  end
end
