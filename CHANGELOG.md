# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] - 

### Added
- Make `Currency` JSON-serializable

## [0.21.0] - 2025-06-05

### Added
- Add support for Lucky v1.4

### Fixed
- Fix `TypeCastError` in `Bill::UpdateCreditNoteLineItems#rollback_failed_delete_credit_note_items`
- Fix `TypeCastError` in `Bill::UpdateInvoiceLineItems#rollback_failed_delete_credit_note_items`
- Allow nil in attribute size validations
- Fix compile error calling `.compare_versions` with `Bill::VERSION`

### Changed
- Make `Bill::NeedsLineItems#keyed_line_items` getter private

## [0.20.0] - 2025-02-22

### Added
- Add `Bill::NeedsLineItems#many_nested_errors`
- Add `Bill::NeedsLineItems#save_line_items`

### Fixed
- Ensure parent record validation is applied for create operations

## [0.19.3] - 2024-10-23

### Fixed
- Add support for Lucky v1.3
- Add support for Crystal v1.13
- Add support for Crystal v1.14

## [0.19.2] - 2024-09-11

### Fixed
- Add back presets removed unitentionally

## [0.19.1] - 2024-09-11

### Removed
- Remove model association presets

## [0.19.0] - 2024-09-11

### Added
- Allow paying for a given invoice
- Add sales receipts (invoices paid for on the spot)
- Add `Api::DirectReceipts::Create` action
- Add `Api::DirectReceipts::Edit` action
- Add `Api::DirectReceipts::New` action
- Add `Api::DirectReceipts::Update` action
- Add `DirectReceipts::Create` action
- Add `DirectReceipts::Edit` action
- Add `DirectReceipts::New` action
- Add `DirectReceipts::Update` action

### Changed
- Allow manually setting `created_at` when finalizing documents
- Rename `Bill::SendDirectReceiptEmail` to `Bill::SendFinalizedDirectReceiptEmail`
- Merge mixin presets into their respective main modules
- Rename `ReceivePayment` operation to `CreateReceipt`
- Rename `ReceiveDirectPayment` operation to `CreateDirectReceipt`

### Fixed
- Auto mark invoices as paid only when transaction was newly finalized
- Auto mark invoices as paid in `UpdateTransaction` operation
- Assign finalized receipt validation error in `RefundPayment` to `status` attribute

## [0.18.0] - 2024-07-27

### Added
- Add `Bill::User#billing_details` abstract method

### Changed
- Limit description lengths to mitigate potential DoS
- Limit notes lengths to mitigate potential DoS

## [0.17.0] - 2024-06-02

### Changed
- Replace `Transaction#metadata` database column with a polymorphic `Transaction#source`

## [0.16.1] - 2024-05-16

### Fixed
- Fix CI issues with Lucky v1.2

### Changed
- Replace receipt ID variable with reference in refund description translation

## [0.16.0] - 2024-03-07

### Added
- Add `Int#credit?` method
- Add `Int#debit?` method

### Removed
- Remove `Ledger.credit?` method
- Remove `Ledger.debit?` method
- Remove `Ledger.zero?` method

## [0.15.2] - 2024-03-01

### Removed
- Remove redundant uniqueness check when automatically setting `reference`

## [0.15.1] - 2023-12-26

### Fixed
- Compare invoice due *days* using local timezone

## [0.15.0] - 2023-11-17

### Added
- Add support for Lucky v1.1
- Add `UpdateDirectReceipt` operation

### Fixed
- Send direct receipt emails **only** for finalized transactions
- Add `TransactionMetadata#credit_note_id` only when `CreditNote` model exists
- Add `TransactionMetadata#invoice_id` only when `Invoice` model exists
- Add `TransactionMetadata#receipt_id` only when `Receipt` model exists

## [0.14.4] - 2023-10-27

### Fixed
- Avoid possible bugs with truthiness checks for `Bool` operation attributes

## [0.14.3] - 2023-10-21

### Added
- Add `Bill::SetTransactionAmount` operation mixin

### Fix
- Fix change from credit to debit amount not working in `UpdateTransaction`

## [0.14.2] - 2023-10-20

### Fixed
- Fix `PQ::PQError` in transaction update operations when `status` is not set

### Changed
- Require `status` in `Bill::ValidateTransaction` operation mixin

## [0.14.1] - 2023-10-19

### Fixed
- Fix finalized receipt transactions not created

## [0.14.0] - 2023-10-11

### Added
- Add `credit : Bool` attribute to `CreateTransaction` operation
- Add `credit : Bool` attribute to `UpdateTransaction` operation
- Add `Api::FinalizedTransactions::*` actions
- Add `FinalizedTransactions::*` actions

### Removed
- Remove `CreateCreditTransaction` operation
- Remove `CreateDebitTransaction` operation
- Remove `Api::CreditTransactions::*` actions
- Remove `Api::DebitTransactions::*` actions
- Remove `CreditTransactions::*` actions
- Remove `DebitTransactions::*` actions

## [0.13.0] - 2023-10-10

### Added
- Add `Transaction#status` column
- Allow setting custom quantity and amount/price column types

### Changed
- Relax `types` parameter type restriction for `Ledger.balance` to `Indexable(TransactionType)`
- Add `time` parameter to `InvoiceQuery#is_due` method
- Add `time` parameter to `InvoiceQuery#is_not_due` method
- Add `time` parameter to `InvoiceQuery#is_overdue` method
- Add `time` parameter to `InvoiceQuery#is_not_overdue` method
- Add `time` parameter to `InvoiceQuery#is_underdue` method
- Add `time` parameter to `InvoiceQuery#is_not_underdue` method

## [0.12.1] - 2023-09-21

### Fixed
- Compare `price_mu` param as `Float64` instead of `Int32` in `Bill::NeedsLineItems`

## [0.12.0] - 2023-09-20

### Added
- Add `Transaction#balance(User::PrimaryKeyType, ...)` methods
- Add `Bill::ReferenceColumns` model mixin

### Fixed
- Support namespaced parent model types

### Changed
- Add `user` parameter type restriction to `Ledger.balance` methods

## [0.11.0] - 2023-06-02

### Changed
- Upgrade `GrottoPress/lucille` shard to v1.0
- Do not skip default validations in operations outside *Bill*

### Removed
- Remove `ApiAction` and `BrowserAction` from presets

## [0.10.0] - 2023-05-02

### Changed
- Upgrade `GrottoPress/lucille` shard to v0.11

## [0.9.0] - 2023-03-13

### Added
- Add support for CockroachDB

### Fixed
- Do a case-insensitive search when validating `reference` uniqueness

### Changed
- Upgrade to support *Lucky* v1.0

## [0.8.0] - 2023-01-09

### Added
- Add `CreditNote#counter` column for use in references
- Add `Invoice#counter` column for use in references
- Add `Receipt#counter` column for use in references
- Add `Transaction#counter` column for use in references
- Add `Ledger.balance_fm` method
- Pay earliest invoices first if they have same due date
- Add `Bill::CreditNoteFromCreditNoteId` operation mixin
- Add `Bill::InvoiceFromInvoiceId` operation mixin
- Add `CreditNoteTotals#line_items_fm`
- Add `InvoiceTotals#credit_notes_fm`
- Add `InvoiceTotals#line_items_fm`

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
