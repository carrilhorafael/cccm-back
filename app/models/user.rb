class User < ApplicationRecord
  has_secure_password

  has_many :memberships, dependent: :destroy
  belongs_to :church
  has_many :ministeries, through: :memberships

  validates :name, :email, :birthdate, :marital_status, :location, :phone, presence: true
  validates :password_confirmation, presence: true, :if => :password
  validates :email, uniqueness: { case_sensitive: true }
  validate :birthdate_must_be_past

  enum marital_status:{
    "Solteiro(a)": 0,
    "Casado(a)": 1,
    "Viúvo(a)": 2,
    "Divorciado(a)": 3,
    "Separado(a)": 4
  }

  enum gender:{
    "Masculino": 0,
    "Feminino": 1
  }

  def age
    ((Date.today - self.birthdate)/365.25).to_i
  end

  def birthdate_must_be_past
    if Date.today < birthdate
      errors.add(:birthdate, "must be past")
    end
  end

  def set_default_password
    self.password = SecureRandom.alphanumeric(36)
    self.password_confirmation = self.password
  end

  def has_access?
    self.access_garantied_at != nil
  end
end
