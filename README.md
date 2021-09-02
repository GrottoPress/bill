# Bill

**Bill** is an Accounts Receivable automation system for *Lucky* framework. It includes tools for creating and tracking invoices, credit notes, receipts and more.

## Documentation

Find the complete documentation in the `docs/` directory of this repository.

## Todo

- [ ] Ledger
- [x] Invoices
- [ ] Taxes
- [ ] Discounts
- [ ] Credit Notes
- [ ] Receipts
- [ ] Businesses

## Development

Create a `.env.sh` file:

```bash
#!/bin/bash

export DATABASE_URL='postgres://postgres:password@localhost:5432/bill_spec'
```

Update the file with your own details. Then run tests with `source .env.sh && crystal spec`.

## Contributing

1. [Fork it](https://github.com/GrottoPress/bill/fork)
1. Switch to the `master` branch: `git checkout master`
1. Create your feature branch: `git checkout -b my-new-feature`
1. Make your changes, updating changelog and documentation as appropriate.
1. Commit your changes: `git commit`
1. Push to the branch: `git push origin my-new-feature`
1. Submit a new *Pull Request* against the `GrottoPress:master` branch.
