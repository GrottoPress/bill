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
    end
  end
end
