module Bill::NeedsLineItems
  macro included
    getter save_line_items do
      Array(Union(
        {{ T }}Item::SaveOperation,
        {{ T }}Item::DeleteOperation
      )).new(
        keyed_line_items.size,
        {{ T }}Item::SaveOperation.new
      )
    end

    needs line_items : Array(Hash(String, String))

    # Adds the order in which the line items were received from
    # the request to each item.
    #
    # This should help us send back errors in the same order, so the
    # frontend can know which errors belong to which item.
    getter keyed_line_items : Array(Hash(String, String)) do
      line_items.map_with_index do |line_item, i|
        line_item.tap  { |item| item["key"] = i.to_s }
      end
    end

    def line_items_to_create
      line_items_to_save.reject(&.["id"]?)
    end

    def line_items_to_update
      line_items_to_save.select(&.["id"]?)
    end

    def line_items_to_delete
      keyed_line_items - line_items_to_save
    end

    def line_items_to_save
      keyed_line_items.reject do |line_item|
        line_item["quantity"]?.try { |quantity| Quantity.new(quantity) == 0 } ||
        line_item["price"]?.try { |price| Amount.new(price) == 0 } ||
        line_item["price_mu"]?.try(&.to_f.== 0)
      end
    end

    # Collect errors in the same order as we received the line items
    # from request
    def many_nested_errors
      {% if @type.methods.any?(&.name.== :many_nested_errors.id) %}
        errors = previous_def
      {% elsif @type.ancestors.any? do |ancestor|
        ancestor.methods.any?(&.name.== :many_nested_errors.id)
      end %}
        errors = super
      {% else %}
        errors = Hash(Symbol, Array(Hash(Symbol, Array(String)))).new
      {% end %}

      errors.tap do |_errors|
        _errors[:save_line_items] = save_line_items.map(&.errors)
      end
    end
  end
end
