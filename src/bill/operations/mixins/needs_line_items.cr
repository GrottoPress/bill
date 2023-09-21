module Bill::NeedsLineItems
  macro included
    needs line_items : Array(Hash(String, String))

    def line_items
      previous_def.reject do |line_item|
        line_item.empty? ||
        line_item["quantity"]?.try(&.to_i?.try &.< 0) ||
        line_item["price"]?.try(&.to_i?.try &.< 0) ||
        line_item["price_mu"]?.try(&.to_f?.try &.< 0)
      end
    end

    def line_items_to_create
      line_items_to_save.reject(&.["id"]?)
    end

    def line_items_to_update
      line_items_to_save.select(&.["id"]?)
    end

    def line_items_to_delete
      line_items - line_items_to_save
    end

    def line_items_to_save
      line_items.reject do |line_item|
        line_item["quantity"]?.try(&.to_i?.== 0) ||
        line_item["price"]?.try(&.to_i?.== 0) ||
        line_item["price_mu"]?.try(&.to_f?.== 0)
      end
    end
  end
end
