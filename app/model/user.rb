require 'bcrypt'

class User
  include Virtus.model
  include Veto.validator
  include Oriental::Document
  include Oriental::Graph::Edge

  attr_accessor :password, :password_confirmation

  attribute :rid, String
  attribute :username, String
  attribute :crypted_pass, String
  attribute :email, String

  validates :username, presence: true
  validates :email, presence: true

  validates :password, presence: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validate :confirmation_of_password, if: :password_required?

  def password_required?(obj)
    new? or password
  end

  def confirmation_of_password(obj)
    errors.add(:password_confirmation, 'should match with password') if password != password_confirmation
  end

  before :save, :crypt_password
  before :save, :clear_password_fields

  def crypt_password
    self.crypted_pass = BCrypt::Password.create(password) if password
  end

  def clear_password_fields
    self.password = self.password_confirmation = nil
  end

  def crypted_pass
    super ? BCrypt::Password.new(super) : :no_password
  end

  def authenticate(password)
    crypted_pass == password
  end

  def self.authenticate(username, password)
    u = find_by(name: username)
    u && u.authenticate(password) ? u : nil
  end
    
end
