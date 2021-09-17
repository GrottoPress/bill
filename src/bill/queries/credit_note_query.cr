module Bill::CreditNoteQuery
  macro included
    def is_draft
      status(:draft)
    end

    def is_not_draft
      status.not.eq(:draft)
    end

    def is_open
      status(:open)
    end

    def is_not_open
      status.not.eq(:open)
    end

    def is_finalized
      is_not_draft
    end

    def is_not_finalized
      is_draft
    end
  end
end
