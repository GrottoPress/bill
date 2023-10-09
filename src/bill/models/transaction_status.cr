module Bill::TransactionStatus
  macro included
    __enum TransactionStatus do
      Draft
      Open

      def finalized? : Bool
        !draft?
      end
    end

    struct TransactionStatus
      extend Bill::StatusHelpers
    end
  end
end
