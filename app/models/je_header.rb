class JeHeader < ActiveRecord::Base
  has_many :je_lines
  accepts_nested_attributes_for :je_lines
end
