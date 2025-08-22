module Bill::InvoicesLedger
  macro included
    def invoices
      Invoices.new(self)
    end

    def self.invoices
      new.invoices
    end

    private struct Invoices
      def initialize(@ledger : Bill::Ledger)
        @type = TransactionType.new(:invoice)
      end

      def balance(
        user : Bill::HasManyTransactions,
        from : Time? = nil,
        till : Time? = nil
      )
        @ledger.balance(user, @type, from, till)
      end

      def balance(
        transactions : Array(Bill::Transaction),
        from : Time? = nil,
        till : Time? = nil
      )
        @ledger.balance(transactions, @type, from, till)
      end

      def balance!(
        user : Bill::HasManyTransactions? = nil,
        from : Time? = nil,
        till : Time? = nil
      )
        @ledger.balance!(user, @type, from, till)
      end

      def owing?(user)
        balance = @ledger.balance(user)
        balance if balance.debit?
      end

      def owing!(user)
        balance = @ledger.balance!(user)
        balance if balance.debit?
      end

      # Does user still owe if you do not factor in underdue
      # and due invoices?
      def over_owing?(user)
        balance = @ledger.balance(user) - amount_not_overdue(user)
        balance if balance.debit?
      end

      # :ditto:
      def over_owing!(user)
        balance = Amount.new(0)

        user.class.database.transaction do
          balance += @ledger.balance!(user) - amount_not_overdue!(user)
        end

        balance if balance.debit?
      end

      private def amount_not_overdue(user)
        user.invoices.select do |invoice|
          invoice.open? && !invoice.overdue?
        end.sum(&.net_amount)
      end

      private def amount_not_overdue!(user)
        InvoiceQuery.new
          .where("#{@ledger.foreign_key(user)} = ?", user.id.to_s)
          .is_open
          .is_not_overdue
          .results
          .sum(&.net_amount)
      end
    end
  end
end
