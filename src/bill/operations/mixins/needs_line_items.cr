module Bill::NeedsLineItems
  macro included
    needs line_items : Array(Hash(String, String))

    def line_items
      previous_def.reject(&.empty?)
    end

    def line_items_to_create
      line_items.reject { |line_item| line_item["id"]? || line_item["delete"]? }
    end

    def line_items_to_delete
      line_items.select(&.["delete"]?)
    end

    # Equivalent to `line_items_to_create + line_items_to_update`
    def line_items_to_save
      line_items.reject(&.["delete"]?)
    end

    def line_items_to_update
      line_items.select do |line_item|
        line_item.["id"]? && !line_item.["delete"]?
      end
    end
  end
end
