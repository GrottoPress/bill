module Bill::ReceiptStatus
  macro included
    string_enum ReceiptStatus do
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
