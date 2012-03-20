require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  def new_application(attributes = {})
    attributes[:username] ||= 'foo'
    attributes[:email] ||= 'foo@example.com'
    attributes[:password] ||= 'abc123'
    attributes[:password_confirmation] ||= attributes[:password]
    application = Application.new(attributes)
    application.valid? # run validations
    application
  end

  def setup
    Application.delete_all
  end

  def test_valid
    assert new_application.valid?
  end

  def test_require_username
    assert_equal ["can't be blank"], new_application(:username => '').errors[:username]
  end

  def test_require_password
    assert_equal ["can't be blank"], new_application(:password => '').errors[:password]
  end

  def test_require_well_formed_email
    assert_equal ["is invalid"], new_application(:email => 'foo@bar@example.com').errors[:email]
  end

  def test_validate_uniqueness_of_email
    new_application(:email => 'bar@example.com').save!
    assert_equal ["has already been taken"], new_application(:email => 'bar@example.com').errors[:email]
  end

  def test_validate_uniqueness_of_username
    new_application(:username => 'uniquename').save!
    assert_equal ["has already been taken"], new_application(:username => 'uniquename').errors[:username]
  end

  def test_validate_odd_characters_in_username
    assert_equal ["should only contain letters, numbers, or .-_@"], new_application(:username => 'odd ^&(@)').errors[:username]
  end

  def test_validate_password_length
    assert_equal ["is too short (minimum is 4 characters)"], new_application(:password => 'bad').errors[:password]
  end

  def test_require_matching_password_confirmation
    assert_equal ["doesn't match confirmation"], new_application(:password_confirmation => 'nonmatching').errors[:password]
  end

  def test_generate_password_hash_and_salt_on_create
    application = new_application
    application.save!
    assert application.password_hash
    assert application.password_salt
  end

  def test_authenticate_by_username
    Application.delete_all
    application = new_application(:username => 'foobar', :password => 'secret')
    application.save!
    assert_equal application, Application.authenticate('foobar', 'secret')
  end

  def test_authenticate_by_email
    Application.delete_all
    application = new_application(:email => 'foo@bar.com', :password => 'secret')
    application.save!
    assert_equal application, Application.authenticate('foo@bar.com', 'secret')
  end

  def test_authenticate_bad_username
    assert_nil Application.authenticate('nonexisting', 'secret')
  end

  def test_authenticate_bad_password
    Application.delete_all
    new_application(:username => 'foobar', :password => 'secret').save!
    assert_nil Application.authenticate('foobar', 'badpassword')
  end
end
