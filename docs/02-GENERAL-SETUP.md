## General Setup

1. Configure:

   *Bill* uses *Habitat*, which comes bundled with *Lucky*, for configuration.

   ---
   ```crystal
   # ->>> config/bill.cr

   Bill.configure do |settings|
     # ...
     settings.currency = Currency.new("GHS", "GH₵")
     # ...
   end
   ```
