class User < Ohm::Model
  extend Shield::Model

  attribute :email
  attribute :crypted_password
  attribute :first_name
  attribute :last_name
  attribute :admin

  unique :email
  collection :packages, Package

  attr :password

  def self.fetch(identifier)
    with(:email, canonical(identifier))
  end

  def self.canonical(identifier)
    identifier.to_s.downcase.strip
  end

  def latest_packages
    packages.sort_by(:created_at, order: "DESC")
  end

  def email=(email)
    @_attributes[:email] = self.class.canonical(email)
  end

  def admin?
    !! admin
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def password=(pass)
    self.crypted_password = Shield::Password.encrypt(pass.to_s)
    @password = pass
  end
end
