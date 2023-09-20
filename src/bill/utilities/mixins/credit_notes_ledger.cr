module Bill::CreditNotesLedger
  macro included
    def credit_notes
      CreditNotes.new(self)
    end

    def self.credit_notes
      new.credit_notes
    end

    struct CreditNotes
      def initialize(@ledger : Bill::Ledger)
        @type = TransactionType.new(:credit_note)
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
    end
  end
end
