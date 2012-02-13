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
      assert_confirmed(:password, :password_confirmation)
    end
  end

  def create
    User.create(attributes.reject { |att, _| att == :password_confirmation })
  end

private
  def assert_confirmed(att1, att2, err = [att2, :not_valid])
    assert send(att1) == send(att2), err
  end
end
