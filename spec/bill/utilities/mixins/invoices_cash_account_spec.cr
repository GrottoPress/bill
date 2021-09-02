require "../../../spec_helper"

describe Bill::InvoicesCashAccount do
  describe "#amount" do
    it "returns the correct amount" do
      description = "New invoice"
      notes = "A note"

      user = UserFactory.create

      invoice = InvoiceFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(3).price(14)

      invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(15)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)
        .created_at(1.day.from_now)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(5).price(12)
      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(7).price(10)

      user = UserQuery.new
        .preload_invoices(InvoiceQuery.new.preload_line_items)
        .find(user.id)

      user_2 = UserQuery.new
        .preload_invoices(InvoiceQuery.new.preload_line_items)
        .find(user_2.id)

      user.invoices_account.amount.should eq(3 * 14 + 2 * 15)
      user_2.invoices_account.amount.should eq(5 * 12 + 7 * 10)

      user.invoices_account.amount(1.day.ago).should(eq 2 * 15)
      user.invoices_account.amount(till: 1.day.ago).should eq(3 * 14)
      user.invoices_account.amount(4.days.ago, 2.days.ago).should(eq 3 * 14)
    end
  end

  describe "#amount!" do
    it "returns the correct amount" do
      description = "New invoice"
      notes = "A note"

      user = UserFactory.create

      invoice = InvoiceFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(3).price(14)

      invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(15)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)
        .created_at(1.day.from_now)

      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(5).price(12)
      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(7).price(10)

      user.invoices_account.amount!.should eq(3 * 14 + 2 * 15)
      user_2.invoices_account.amount!.should eq(5 * 12 + 7 * 10)

      user.invoices_account.amount!(1.day.ago).should(eq 2 * 15)
      user.invoices_account.amount!(till: 1.day.ago).should eq(3 * 14)
      user.invoices_account.amount!(4.days.ago, 2.days.ago).should(eq 3 * 14)
    end
  end

  describe "#due_amount" do
    it "returns the correct amount" do
      description = "New invoice"
      notes = "A note"

      user = UserFactory.create

      invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(44)

      invoice = InvoiceFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .due_at(Time.utc)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(9).price(22)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)
        .created_at(1.day.from_now)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(6).price(20)
      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(8).price(33)

      user = UserQuery.new
        .preload_invoices(InvoiceQuery.new.preload_line_items)
        .find(user.id)

      user_2 = UserQuery.new
        .preload_invoices(InvoiceQuery.new.preload_line_items)
        .find(user_2.id)

      user.invoices_account.due_amount.should eq(9 * 22)
      user_2.invoices_account.due_amount.should eq(0)

      user.invoices_account.due_amount(1.day.ago).should(eq 0)
      user.invoices_account.due_amount(till: 1.day.ago).should eq(9 * 22)
      user.invoices_account.due_amount(4.days.ago, 2.days.ago).should(eq 9 * 22)
    end
  end

  describe "#due_amount!" do
    it "returns the correct amount" do
      description = "New invoice"
      notes = "A note"

      user = UserFactory.create

      invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(44)

      invoice = InvoiceFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .due_at(Time.utc)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(9).price(22)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)
        .created_at(1.day.from_now)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(6).price(20)
      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(8).price(33)

      user.invoices_account.due_amount!.should eq(9 * 22)
      user_2.invoices_account.due_amount!.should eq(0)

      user.invoices_account.due_amount!(1.day.ago).should(eq 0)
      user.invoices_account.due_amount!(till: 1.day.ago).should eq(9 * 22)

      user.invoices_account
        .due_amount!(4.days.ago, 2.days.ago)
        .should(eq 9 * 22)
    end
  end

  describe "#overdue_amount" do
    it "returns the correct amount" do
      description = "New invoice"
      notes = "A note"

      user = UserFactory.create

      invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(3).price(14)

      invoice = InvoiceFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .due_at(1.day.ago)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(15)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)
        .created_at(1.day.from_now)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(5).price(12)
      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(7).price(10)

      user = UserQuery.new
        .preload_invoices(InvoiceQuery.new.preload_line_items)
        .find(user.id)

      user_2 = UserQuery.new
        .preload_invoices(InvoiceQuery.new.preload_line_items)
        .find(user_2.id)

      user.invoices_account.overdue_amount.should eq(2 * 15)
      user_2.invoices_account.overdue_amount.should eq(0)

      user.invoices_account.overdue_amount(1.day.ago).should(eq 0)
      user.invoices_account.overdue_amount(till: 1.day.ago).should eq(2 * 15)

      user.invoices_account
        .overdue_amount(4.days.ago, 2.days.ago)
        .should(eq 2 * 15)
    end
  end

  describe "#overdue_amount!" do
    it "returns the correct amount" do
      description = "New invoice"
      notes = "A note"

      user = UserFactory.create

      invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(3).price(14)

      invoice = InvoiceFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .due_at(1.day.ago)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(15)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)
        .created_at(1.day.from_now)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(5).price(12)
      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(7).price(10)

      user.invoices_account.overdue_amount!.should eq(2 * 15)
      user_2.invoices_account.overdue_amount!.should eq(0)

      user.invoices_account.overdue_amount!(1.day.ago).should(eq 0)
      user.invoices_account.overdue_amount!(till: 1.day.ago).should(eq 2 * 15)

      user.invoices_account
        .overdue_amount!(4.days.ago, 2.days.ago)
        .should(eq 2 * 15)
    end
  end

  describe "#underdue_amount" do
    it "returns the correct amount" do
      description = "New invoice"
      notes = "A note"

      user = UserFactory.create

      invoice = InvoiceFactory.create &.user_id(user.id)
        .due_at(1.day.ago)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(3).price(14)

      invoice = InvoiceFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(15)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)
        .created_at(1.day.from_now)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(5).price(12)
      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(7).price(10)

      user = UserQuery.new
        .preload_invoices(InvoiceQuery.new.preload_line_items)
        .find(user.id)

      user_2 = UserQuery.new
        .preload_invoices(InvoiceQuery.new.preload_line_items)
        .find(user_2.id)

      user.invoices_account.underdue_amount.should eq(2 * 15)
      user_2.invoices_account.underdue_amount.should(eq 5 * 12 + 7 * 10)

      user.invoices_account.underdue_amount(1.day.ago).should(eq 0)
      user.invoices_account.underdue_amount(till: 1.day.ago).should eq(2 * 15)

      user.invoices_account
        .underdue_amount(4.days.ago, 2.days.ago)
        .should(eq 2 * 15)
    end
  end

  describe "#underdue_amount!" do
    it "returns the correct amount" do
      description = "New invoice"
      notes = "A note"

      user = UserFactory.create

      invoice = InvoiceFactory.create &.user_id(user.id)
        .due_at(1.day.ago)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(3).price(14)

      invoice = InvoiceFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(15)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)
        .created_at(1.day.from_now)
        .status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(5).price(12)
      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(7).price(10)

      user.invoices_account.underdue_amount!.should eq(2 * 15)
      user_2.invoices_account.underdue_amount!.should(eq 5 * 12 + 7 * 10)

      user.invoices_account.underdue_amount!(1.day.ago).should(eq 0)
      user.invoices_account.underdue_amount!(till: 1.day.ago).should(eq 2 * 15)

      user.invoices_account
        .underdue_amount!(4.days.ago, 2.days.ago)
        .should(eq 2 * 15)
    end
  end
end
