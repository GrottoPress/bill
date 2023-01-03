# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] - 

### Added
- Add `CreditNote#counter` column for use in references
- Add `Invoice#counter` column for use in references
- Add `Receipt#counter` column for use in references
- Add `Transaction#counter` column for use in references
- Add `Ledger.balance_fm` method
- Pay earliest invoices first if they have same due date
- Add `Bill::CreditNoteFromCreditNoteId` operation mixin
- Add `Bill::InvoiceFromInvoiceId` operation mixin

### Changed
- Make `Invoice#description` column optional
- Make `CreditNote#description` column optional
- Use a zero quantity or price as a flag to delete an item in `Bill::NeedsLineItems`.

### Removed
- Remove `.max_debt_allowed` setting
- Remove `Ledger.invoices.hard_owing?`
- Remove `Ledger.invoices.hard_owing!`
- Remove `Ledger.invoices.soft_owing?`
- Remove `Ledger.invoices.soft_owing!`
- Remove `Ledger.invoices.over_hard_owing?`
- Remove `Ledger.invoices.over_hard_owing!`
- Remove `Ledger.invoices.over_soft_owing?`
- Remove `Ledger.invoices.over_soft_owing!`

### Fixed
- Fix negative sign stripped in fractional money formats for negative amounts
- Ensure calculated amounts are constant even if modules are included multiple times

## [0.7.0] - 2022-11-21

### Added
- Add `Bill::BelongsToReceipt` model mixin
- Add `Bill::OptionalBelongsToReceipt` model mixin

### Changed
- Upgrade to support *Crystal* v1.6

### Fixed
- Use net amount (instead of full amount) when marking invoices as paid
- Fix `PQ::PQError` (syntax error) in `Ledger.balance!` when using `UUID` primary keys

## [0.6.0] - 2022-10-15

### Changed
- Upgrade to support *Lucky* v1.0.0-rc1

## [0.5.0] - 2022-09-24

### Added
- Add `CreditNote#reference` column
- Add `Invoice#reference` column
- Add `Receipt#reference` column
- Add `Transaction#reference` column
- Add support for all database primary key types (not just `Int64`)

## [0.4.0] - 2022-06-28

### Added
- Add support for *Lucky* v0.30
- Add `Invoice#net_amount_fm` method
- Add `Invoice#net_amount_fm!` method

## [0.3.0] - 2022-03-17

### Added
- Ensure support for *Crystal* v1.3

### Changed
- Use saved status to determine status of create operations
- Respond with HTTP status code `400` in actions if operation failed
- Rename `User#full_address` to `#billing_details`
- Replace `NamedTuple` responses in APIs entirely with serializers

## [0.2.0] - 2022-01-03

### Added
- Add support for *Lucky* v0.29
- Set up i18n with [*Rex*](https://github.com/GrottoPress/rex)

### Changed
- Remove `Lucky::Env` module in favour of [`LuckyEnv`](https://github.com/luckyframework/lucky_env)
- Convert `CreditNoteTotals` to a struct
- Convert `InvoiceTotals` to a struct
- Convert `TransactionMetadata` to a struct

### Removed
- Remove support for *Lucky* v0.28

## [0.1.0] - 2021-11-22

### Added
- Add transactions ledger
- Add invoices
- Add credit notes
- Add receipts
