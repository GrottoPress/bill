module Bill::ValidateHasLineItems
  macro included
    skip_default_validations

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

      id.add_error Rex.t(:"operation.error.{{ T.name
        .split("::")
        .last
        .underscore
        .id }}_items_empty")
    end
  end
end
