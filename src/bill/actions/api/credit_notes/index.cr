module Bill::Api::CreditNotes::Index
  macro included
    # param page : Int32 = 1

    # get "/credit-notes" do
    #   json ListResponse.new(credit_notes: credit_notes, pages: pages)
    # end

    def pages
      paginated_credit_notes[0]
    end

    getter credit_notes : Array(CreditNote) do
      paginated_credit_notes[1].results
    end

    private getter paginated_credit_notes : Tuple(
      Lucky::Paginator,
      CreditNoteQuery
    ) do
      paginate(CreditNoteQuery.new.preload_line_items.created_at.desc_order)
    end
  end
end
