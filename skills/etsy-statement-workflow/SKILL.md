---
name: etsy-statement-workflow
description: Process Etsy monthly statement CSVs into Google Sheets month tabs and exported month PDFs. Use when Codex needs to fill Etsy accounting sheets from local Etsy CSVs, exclude payout rows such as Card Payment, mirror a prior-year reference sheet without editing it, clean copied month templates, or export completed month tabs to month-named PDFs.
---

# Etsy Statement Workflow

Use this workflow for recurring Etsy month-end statement handling.

## Core Rules

- Use Google Drive tools for Google Sheets reads, writes, tab duplication, and PDF exports.
- Treat prior-year workbooks as read-only references unless the user explicitly says otherwise.
- Import only rows where `Type == Fee`.
- Exclude payout rows, especially `Type == Payment` / `Title == Card Payment`.
- Preserve formulas, totals, formatting, and manually inserted images unless the user asks to change them.
- Name exported PDFs with the statement month-end date, not the last transaction date.
  - Example: `Jan 2026` -> `20260131-Etsy-TaxStatement.pdf`

## Workflow

1. Inspect the inputs.
   - Read the target workbook metadata and the month tabs to understand the live structure.
   - Read the reference workbook only for layout and formula patterns.
   - Run `scripts/extract_fee_rows.py` on the Etsy CSV files to confirm row counts, totals, and excluded payout rows before writing anything.

2. Fill the target month tabs.
   - Write only the fee rows into the target workbook.
   - Preserve the CSV row order unless the user asks for another ordering.
   - If a copied tab has too few blank rows above the total row, insert rows before writing the data.
   - After row inserts or deletes, repair the total formulas so they span exactly the imported rows.
   - Write dates as real date values and currency cells as numeric values so sheet formulas continue to work.

3. Clean future tabs when requested.
   - Clear copied transaction rows by clearing `userEnteredValue` in the transaction range.
   - Keep the sheet structure, formatting, and total formulas intact.
   - Rename copied year tabs to the requested year without touching already completed months.

4. Export PDFs.
   - Duplicate each completed month tab into a temporary one-sheet spreadsheet.
   - Export that spreadsheet as PDF through Google Drive.
   - Save the PDF locally using the month-end filename pattern.
   - Validate the result with `pdfinfo`.
   - If needed, use `pdftotext` to confirm the expected totals are present in the export.

5. Report the results.
   - State imported fee row counts and totals per month.
   - Return absolute paths for any saved PDFs.
   - Mention any format differences versus a historical reference PDF, such as page count changes.

## Local CSV Helper

Use the bundled parser before writing to Sheets:

```bash
scripts/extract_fee_rows.py file1.csv file2.csv --json
```

This script:

- keeps only fee rows
- excludes payout rows such as `Card Payment`
- computes fee totals and excluded payout totals
- derives the statement month and month-end filename stem
- returns normalized row data for Sheet writes

Use `--summary-only` when only counts and totals are needed.

## Expected CSV Shape

The Etsy exports used for this workflow contain:

- `Date`
- `Type`
- `Title`
- `Info`
- `Currency`
- `Amount`
- `Fees & Taxes`
- `Net`
- `Tax Details`

The first eight columns are typically enough for the Google Sheet workflow. Ignore `Tax Details` unless the target sheet explicitly uses it.

## PDF Notes

- Google Drive exports may come back as base64 PDF content inside the connector response.
- If that happens, decode the payload locally and write the bytes to the destination path.
- Page size should stay `612 x 792 pts (letter)` for consistency with standard Google Sheets exports.
- Matching content matters more than matching browser metadata fields such as `Creator` or `Producer`.

## Limits

- Replacing a Google Sheets image inserted "in cell" from a local PNG is still effectively manual with the current toolset.
- If the user provides stable public image URLs, `IMAGE()` may be an acceptable fallback, but that is a different workflow from true in-cell image insertion.
