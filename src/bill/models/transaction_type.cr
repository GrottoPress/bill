module Bill::TransactionType
  macro included
    __enum TransactionType do
      Invoice
      CreditNote
      Receipt

      def to_s
        if credit_note?
          "Credit Note"
        else
          super
        end
      end
    end
  end
end
