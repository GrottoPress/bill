module Bill::InvoiceStatus
  macro included
    __enum InvoiceStatus do
      Draft
      Open
      Paid

      def finalized? : Bool
        !draft?
      end

      def due?(invoice : Invoice) : Bool
        open? && overdue_by(invoice) == 0.days
      end

      def overdue?(invoice : Invoice) : Bool
        open? && overdue_by(invoice) > 0.days
      end

      def underdue?(invoice : Invoice) : Bool
        open? && overdue_by(invoice) < 0.days
      end

      private def overdue_by(invoice) : Time::Span
        Time.utc.at_beginning_of_day - invoice.due_on
      end
    end

    struct InvoiceStatus
      def self.now_finalized?(status : Avram::Attribute)
        status.value.try do |value|
          return false unless value.finalized?
          !status.original_value || !status.original_value.try &.finalized?
        end
      end
    end
  end
end
