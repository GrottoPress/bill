module Bill::ReceiptsLedger
  macro included
    def receipts
      Receipts.new(self)
    end

    def self.receipts
      new.receipts
    end

    struct Receipts
      def initialize(@ledger : Bill::Ledger)
        @type = TransactionType.new(:receipt)
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
