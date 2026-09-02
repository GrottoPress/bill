module Bill::CreditNoteStatus
  macro included
    string_enum CreditNoteStatus do
      Draft
      Open

      def finalized? : Bool
        !draft?
      end
    end

    struct CreditNoteStatus
      extend Bill::StatusHelpers
    end
  end
end
