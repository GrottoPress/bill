module Bill::CreditNoteItems::Index
  macro included
    # param page : Int32 = 1

    # get "/credit-notes/:credit_note_id/line-items" do
    #   html IndexPage, credit_note_items: credit_note_items, pages: pages
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
