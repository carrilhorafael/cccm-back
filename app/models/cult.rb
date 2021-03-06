class Cult < ApplicationRecord
  belongs_to :church
  has_many :proselytes

  validate :date_of_must_be_past
  validates :responsible_name, presence: true
  validates :description, length: { maximum: 512 }

  def date_of_must_be_past
    if self.date_of > Date.today
      self.errors.add(:date_of, 'tem que ser no passado')
    end
  end
end
