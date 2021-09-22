module Bill::ReceiptStatus
  macro included
    __enum ReceiptStatus do
      Draft
      Open

      def finalized? : Bool
        !draft?
      end
    end

    struct ReceiptStatus
      extend Bill::StatusHelpers
    end
  end
end
