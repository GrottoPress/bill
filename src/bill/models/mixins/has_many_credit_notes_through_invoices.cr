module Bill::HasManyCreditNotesThroughInvoices
  macro included
    include Bill::HasManyInvoices

    def credit_notes : Array(CreditNote)
      invoices.flat_map &.credit_notes
    end

    def credit_notes! : Array(CreditNote)
      InvoiceQuery.preload_credit_notes(invoices!).flat_map &.credit_notes
    end
  end
end
