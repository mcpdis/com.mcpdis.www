class CreateUser < Scrivener
  attr_accessor :email
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :first_name
  attr_accessor :last_name

  def validate
    assert_email(:email)
    assert_present(:first_name)
    assert_present(:last_name)

    if assert_present(:password)
      assert_length(:password, 6..1000)
      assert_confirmed(:password)
    end
  end

  def create
    User.create(attributes.reject { |att, _| att == :password_confirmation })
  end

private
  def assert_confirmed(att1, att2 = :"#{att1}_confirmation", err = [att2, :not_valid])
    assert send(att1) == send(att2), err
  end
end

class User < Ohm::Model
  extend Shield::Model

  attribute :email
  attribute :crypted_password
  attribute :first_name
  attribute :last_name
  attribute :admin

  unique :email

  attr :password

  def self.fetch(identifier)
    with(:email, canonical(identifier))
  end

  def self.canonical(identifier)
    identifier.to_s.downcase.strip
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
