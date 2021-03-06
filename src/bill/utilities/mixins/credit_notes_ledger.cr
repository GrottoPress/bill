module Bill::CreditNotesLedger
  macro included
    def credit_notes
      CreditNotes.new(self)
    end

    def self.credit_notes
      new.credit_notes
    end

    private struct CreditNotes
      def initialize(@ledger : Bill::Ledger)
        @type = TransactionType.new(:credit_note)
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
