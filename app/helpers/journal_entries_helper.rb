module JournalEntriesHelper

  def calculate_je_line_totals(je_lines)
    debit_total = 0
    credit_total = 0

    je_lines.each do |jel|
      debit_total += jel.debit_amount
      credit_total += jel.credit_amount
    end

    { debit: debit_total, credit: credit_total }
  end
end
