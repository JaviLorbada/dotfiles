#!/usr/bin/env python3

import argparse
import calendar
import csv
import json
from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal
from pathlib import Path
from typing import Iterable


DATE_FORMAT = "%B %d, %Y"


@dataclass
class StatementRow:
    date: str
    row_type: str
    title: str
    info: str
    currency: str
    amount: str
    fees_taxes: str
    net: str
    tax_details: str

    @classmethod
    def from_csv(cls, row: dict[str, str]) -> "StatementRow":
        return cls(
            date=row["Date"].strip(),
            row_type=row["Type"].strip(),
            title=row["Title"].strip(),
            info=row["Info"].strip(),
            currency=row["Currency"].strip(),
            amount=row["Amount"].strip(),
            fees_taxes=row["Fees & Taxes"].strip(),
            net=row["Net"].strip(),
            tax_details=row.get("Tax Details", "").strip(),
        )

    @property
    def date_value(self) -> datetime:
        return datetime.strptime(self.date, DATE_FORMAT)

    def to_dict(self) -> dict[str, object]:
        return {
            "date": self.date,
            "date_iso": self.date_value.date().isoformat(),
            "type": self.row_type,
            "title": self.title,
            "info": self.info,
            "currency": self.currency,
            "amount": self.amount,
            "amount_value": str(parse_money(self.amount)),
            "fees_taxes": self.fees_taxes,
            "fees_taxes_value": str(parse_money(self.fees_taxes)),
            "net": self.net,
            "net_value": str(parse_money(self.net)),
            "tax_details": self.tax_details,
        }


def parse_money(raw: str) -> Decimal:
    value = raw.strip()
    if not value or value == "--":
        return Decimal("0")
    negative = False
    if value.startswith("(") and value.endswith(")"):
        negative = True
        value = value[1:-1]
    value = value.replace("€", "").replace("$", "").replace(",", "").strip()
    if value.startswith("-"):
        negative = True
        value = value[1:]
    amount = Decimal(value)
    return -amount if negative else amount


def month_end(dt: datetime) -> datetime:
    last_day = calendar.monthrange(dt.year, dt.month)[1]
    return dt.replace(day=last_day)


def load_rows(path: Path) -> list[StatementRow]:
    with path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        return [StatementRow.from_csv(row) for row in reader]


def keep_fee_row(row: StatementRow) -> bool:
    return row.row_type == "Fee" and row.title != "Card Payment"


def summarize(path: Path) -> dict[str, object]:
    rows = load_rows(path)
    if not rows:
        raise ValueError(f"{path} has no data rows")

    dates = [row.date_value for row in rows]
    statement_dt = max(dates)
    end_dt = month_end(statement_dt)

    fee_rows = [row for row in rows if keep_fee_row(row)]
    excluded_rows = [row for row in rows if not keep_fee_row(row)]

    return {
        "source_file": str(path),
        "statement_month": statement_dt.strftime("%Y-%m"),
        "statement_month_name": statement_dt.strftime("%B %Y"),
        "statement_month_end": end_dt.date().isoformat(),
        "pdf_filename_stem": end_dt.strftime("%Y%m%d") + "-Etsy-TaxStatement",
        "row_count_total": len(rows),
        "fee_row_count": len(fee_rows),
        "excluded_row_count": len(excluded_rows),
        "fee_total": str(sum((parse_money(row.net) for row in fee_rows), Decimal("0"))),
        "excluded_total": str(sum((parse_money(row.net) for row in excluded_rows), Decimal("0"))),
        "excluded_titles": sorted({row.title for row in excluded_rows}),
        "rows": [row.to_dict() for row in fee_rows],
    }


def print_summary(results: Iterable[dict[str, object]]) -> None:
    for result in results:
        print(f"FILE: {result['source_file']}")
        print(f"MONTH: {result['statement_month_name']}")
        print(f"MONTH END: {result['statement_month_end']}")
        print(f"PDF STEM: {result['pdf_filename_stem']}")
        print(f"FEE ROWS: {result['fee_row_count']}")
        print(f"EXCLUDED ROWS: {result['excluded_row_count']}")
        print(f"FEE TOTAL: {result['fee_total']}")
        print(f"EXCLUDED TOTAL: {result['excluded_total']}")
        print(f"EXCLUDED TITLES: {', '.join(result['excluded_titles']) or '--'}")
        print("---")


def main() -> int:
    parser = argparse.ArgumentParser(description="Extract fee rows from Etsy monthly statement CSVs.")
    parser.add_argument("csv_files", nargs="+", help="One or more Etsy statement CSV files.")
    parser.add_argument("--json", action="store_true", help="Emit machine-readable JSON.")
    parser.add_argument(
        "--summary-only",
        action="store_true",
        help="Omit the per-row payload from JSON output.",
    )
    args = parser.parse_args()

    results = [summarize(Path(csv_file)) for csv_file in args.csv_files]
    if args.summary_only:
        for result in results:
            result.pop("rows", None)

    if args.json:
        print(json.dumps(results, indent=2, ensure_ascii=False))
    else:
        print_summary(results)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
