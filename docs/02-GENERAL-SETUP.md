## General Setup

1. Configure:

   *Bill* uses *Habitat*, which comes bundled with *Lucky*, for configuration.

   ---
   ```crystal
   # ->>> config/bill.cr

   # If you are going to be dealing with higher or lower money values,
   # set these appropriately.
   #
   alias Amount = Int32 # All amount/price columns will be of this type
   alias Quantity = Int16 # All quantity columns will be of this type

   Bill.configure do |settings|
     # ...
     settings.currency = Currency.new("GHS", "GH₵")
     # ...
   end
   ```
