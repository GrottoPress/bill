module Bill::InvoicesCashAccount
  macro included
    def invoices
      Invoices.new(self)
    end

    private struct Invoices
      def initialize(@account : Bill::CashAccount)
      end

      def amount(since : Time? = nil, till : Time? = nil)
        amount(since, till, :all)
      end

      def amount!(since : Time? = nil, till : Time? = nil)
        amount!(since, till, :all)
      end

      def due_amount(since : Time? = nil, till : Time? = nil)
        amount(since, till, :due)
      end

      def due_amount!(since : Time? = nil, till : Time? = nil)
        amount!(since, till, :due)
      end

      def overdue_amount(since : Time? = nil, till : Time? = nil)
        amount(since, till, :overdue)
      end

      def overdue_amount!(since : Time? = nil, till : Time? = nil)
        amount!(since, till, :overdue)
      end

      def underdue_amount(since : Time? = nil, till : Time? = nil)
        amount(since, till, :underdue)
      end

      def underdue_amount!(since : Time? = nil, till : Time? = nil)
        amount!(since, till, :underdue)
      end

      private def amount(since, till, type)
        @account.raise_if_start_gt_end(since, till)

        invoices = @account.record.invoices

        case type
        when :due
          invoices = invoices.select(&.due?)
        when :overdue
          invoices = invoices.select(&.overdue?)
        when :underdue
          invoices = invoices.select(&.underdue?)
        end

        invoices = invoices.select(&.created_at.<= till) if till
        invoices = invoices.select(&.created_at.>= since) if since

        invoices.sum &.amount
      end

      private def amount!(since, till, type)
        @account.raise_if_start_gt_end(since, till)

        join_query = InvoiceQuery.new.where(
          "#{@account.foreign_key} = ?",
          @account.record.id
        )

        case type
        when :due
          join_query = join_query.is_due
        when :overdue
          join_query = join_query.is_overdue
        when :underdue
          join_query = join_query.is_underdue
        end

        join_query = join_query.created_at.gte(since) if since
        join_query = join_query.created_at.lte(till) if till

        InvoiceItemQuery.new
          .where_invoice(join_query)
          .exec_scalar(&.select_sum "price * quantity")
          .try(&.as(Int64).to_i) || 0
      end
    end
  end
end
