module Bill::ValidateHasLineItems
  macro included
    before_save do
      validate_has_line_items
    end

    private def validate_has_line_items
      return unless {{ T }}Status.now_finalized?(status)

      unless record
        return unless responds_to?(:line_items_to_create) &&
          self.line_items_to_create.empty?
      end

      record.try do |record|
        return unless record.line_items.empty?

        return unless responds_to?(:line_items_to_save) &&
          self.line_items_to_save.empty?
      end

      id.add_error("has no line items")
    end
  end
end
