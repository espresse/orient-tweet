require 'bcrypt'

class User
  include Oriental::Graph::Vertex
  include Oriental::Graph::X

  attr_accessor :password, :password_confirmation

  attribute :rid, Oriental::Rid
  attribute :name, String
  attribute :username, String
  attribute :crypted_pass, String
  attribute :email, String

  validates :username, presence: true
  validates :email, presence: true

  with_options if: :password_required? do
    validates :password, presence: true
    validates :password_confirmation, presence: true
    validate :confirmation_of_password
  end

  before :save, :crypt_password
  before :save, :clear_password_fields

  def password_required?(obj=nil)
    new? or password
  end

  def confirmation_of_password(obj=nil)
    errors.add(:password_confirmation, 'should match with password') if password != password_confirmation
  end

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
