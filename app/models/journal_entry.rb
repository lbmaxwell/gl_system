class JournalEntry < ActiveRecord::Base
  has_many :je_lines
  accepts_nested_attributes_for :je_lines, :allow_destroy => true
  validates :debit_total, numericality: true
  validates :credit_total, numericality: true
  
  validate :debits_equal_credits

  def balanced?
    self.debit_total == credit_total
  end

private

# Custom validators
  def debits_equal_credits
    unless self.balanced?
      errors.add(:journal_entry, "does not balance. Debits must equal credits.")
    end
  end
end
