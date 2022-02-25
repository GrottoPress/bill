module Bill::Api::CreditNotes::Index
  macro included
    # param page : Int32 = 1

    # get "/credit-notes" do
    #   json({
    #     status: "success",
    #     data: {credit_notes: CreditNoteSerializer.for_collection(credit_notes)},
    #     pages: PaginationSerializer.new(pages)
    #   })
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
