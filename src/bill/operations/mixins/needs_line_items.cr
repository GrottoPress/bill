module Bill::NeedsLineItems
  macro included
    needs line_items : Array(Hash(String, String))

    def line_items
      previous_def.reject! do |line_item|
        line_item.empty? ||
        line_item["quantity"]?.try { |quantity| Quantity.new(quantity) < 0 } ||
        line_item["price"]?.try { |price| Amount.new(price) < 0 } ||
        line_item["price_mu"]?.try(&.to_f.< 0)
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
        line_item["quantity"]?.try { |quantity| Quantity.new(quantity) == 0 } ||
        line_item["price"]?.try { |price| Amount.new(price) == 0 } ||
        line_item["price_mu"]?.try(&.to_f.== 0)
      end
    end
  end
end
