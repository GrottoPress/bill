## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   # ->>> shard.yml

   # ...
   dependencies:
     bill:
       github: GrottoPress/bill
   # ...
   ```

1. Run `shards install`

1. In your app's bootstrap, require *Bill*:

   ```crystal
   # ->>> src/app.cr

   # ...
   require "bill"
   # ...
   ```

1. Require *presets*, after models:

```crystal
# ->>> src/app.cr

# ...
require "bill"
# ...
require "./models/base_model"
require "./models/**"

require "bill/presets"
# ...
```
