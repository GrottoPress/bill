# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.21.2] - 2025-08-30

### Fixed
- Fix `TypeCastError` when many nested params contains an empty `id`

## [0.21.1] - 2025-08-22

### Added
- Make `Currency` JSON-serializable

### Fixed
- Wrap balance calculations in a database transaction

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
