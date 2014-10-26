class Account < ActiveRecord::Base

  def number_and_name
    self.number + " - " + self.name
  end
end
