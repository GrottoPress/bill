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
        user,
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
        user : User? = nil,
        from : Time? = nil,
        till : Time? = nil
      )
        @ledger.balance!(user, @type, from, till)
      end

      def owing?(user)
        balance = @ledger.balance(user)
        balance if @ledger.class.debit?(balance)
      end

      def owing!(user)
        balance = @ledger.balance!(user)
        balance if @ledger.class.debit?(balance)
      end

      def soft_owing?(user)
        balance = owing?(user)
        balance if balance.try(&.<= max_debt)
      end

      def soft_owing!(user)
        balance = owing!(user)
        balance if balance.try(&.<= max_debt)
      end

      def hard_owing?(user)
        balance = owing?(user)
        balance if balance.try(&.> max_debt)
      end

      def hard_owing!(user)
        balance = owing!(user)
        balance if balance.try(&.> max_debt)
      end

      # Does user still owe if you do not factor in underdue
      # and due invoices?
      def over_owing?(user)
        balance = @ledger.balance(user) - amount_not_overdue(user)
        balance if @ledger.class.debit?(balance)
      end

      # :ditto:
      def over_owing!(user)
        balance = @ledger.balance!(user) - amount_not_overdue!(user)
        balance if @ledger.class.debit?(balance)
      end

      def over_soft_owing?(user)
        balance = over_owing?(user)
        balance if balance.try(&.<= max_debt)
      end

      def over_soft_owing!(user)
        balance = over_owing!(user)
        balance if balance.try(&.<= max_debt)
      end

      def over_hard_owing?(user)
        balance = over_owing?(user)
        balance if balance.try(&.> max_debt)
      end

      def over_hard_owing!(user)
        balance = over_owing!(user)
        balance if balance.try(&.> max_debt)
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

      private def max_debt
        Bill.settings.max_debt_allowed
      end
    end
  end
end
