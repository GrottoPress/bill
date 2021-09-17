module Bill::Api::CreditNoteItems::Index
  macro included
    # param page : Int32 = 1

    # get "/credit-notes/:credit_note_id/line-items" do
    #   json({
    #     status: "success",
    #     data: {credit_note_items: CreditNoteItemSerializer.for_collection(
    #       credit_note_items
    #     )},
    #     pages: {
    #       current: page,
    #       total: pages.total
    #     }
    #   })
    # end

    def pages
      paginated_credit_note_items[0]
    end

    getter credit_note_items : Array(CreditNoteItem) do
      paginated_credit_note_items[1].results
    end

    private getter paginated_credit_note_items : Tuple(
      Lucky::Paginator,
      CreditNoteItemQuery
    ) do
      paginate CreditNoteItemQuery.new
        .credit_note_id(credit_note_id)
        .created_at.desc_order
    end
  end
end
