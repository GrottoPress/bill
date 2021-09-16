require "../../spec_helper"

describe Bill::Ledger do
  describe "#balance" do
    it "returns correct balance" do
      user = UserFactory.create

      TransactionFactory.create &.user_id(user.id)
        .created_at(3.days.ago)
        .type(:invoice)
        .amount(11)

      TransactionFactory.create &.user_id(user.id).type(:receipt).amount(12)

      user_2 = UserFactory.create &.email("aa@bb.cc")

      TransactionFactory.create &.user_id(user_2.id).type(:invoice).amount(-21)

      TransactionFactory.create &.user_id(user_2.id)
        .created_at(3.days.from_now)
        .type(:invoice)
        .amount(22)

      user = UserQuery.preload_transactions(user)
      user_2 = UserQuery.preload_transactions(user_2)

      transactions = user.transactions + user_2.transactions

      Ledger.balance(transactions).should eq(11 + 12 - 21 + 22)
      Ledger.balance(transactions, from: 1.day.ago).should eq(12 - 21 + 22)
      Ledger.balance(transactions, till: 1.day.ago).should eq(11)
      Ledger.balance(transactions, from: 1.day.ago, till: 1.day.from_now)
        .should(eq 12 - 21)

      Ledger.balance!.should eq(11 + 12 - 21 + 22)
      Ledger.balance!(from: 1.day.ago).should eq(12 - 21 + 22)
      Ledger.balance!(till: 1.day.ago).should eq(11)
      Ledger.balance!(from: 1.day.ago, till: 1.day.from_now).should eq(12 - 21)

      user.balance.should eq(11 + 12)
      Ledger.balance(user, from: 1.day.ago).should eq(12)
      Ledger.balance(user, till: 1.day.ago).should eq(11)
      Ledger.balance(user, from: 1.day.ago, till: 1.day.from_now).should eq(12)

      user.balance!.should eq(11 + 12)
      Ledger.balance!(user, from: 1.day.ago).should eq(12)
      Ledger.balance!(user, till: 1.day.ago).should eq(11)
      Ledger.balance!(user, from: 1.day.ago, till: 1.day.from_now).should eq(12)

      user_2.balance.should eq(22 - 21)
      Ledger.balance(user_2, from: 1.day.ago).should eq(22 - 21)
      Ledger.balance(user_2, till: 1.day.ago).should eq(0)
      Ledger.balance(user_2, from: 1.day.ago, till: 1.day.from_now)
        .should(eq -21)

      user_2.balance!.should eq(22 - 21)
      Ledger.balance!(user_2, from: 1.day.ago).should eq(22 - 21)
      Ledger.balance!(user_2, till: 1.day.ago).should eq(0)
      Ledger.balance!(user_2, from: 1.day.ago, till: 1.day.from_now)
        .should(eq -21)
    end
  end
end
