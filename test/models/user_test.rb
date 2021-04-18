require "test_helper"

class UserTest < ActiveSupport::TestCase
  # User with Valid Email Should be Valid
  test 'user with a valid email should be valid' do
    user = User.new(email: 'test@test.com', password_digest: 'test')
    assert user.valid?
  end
  # User with Invalid Email Should be Invalid
  test 'user with invalid email should be invalid' do
    user = User.new(email: 'test', password_digest: 'test')
    assert_not user.valid?
  end
  # User with Taken Email Should be Invalid
  test 'user with taken email should be invalid' do
    other_user = users(:one)
    user = User.new(email: other_user.email, password_digest: 'test')
    assert_not user.valid?
  end

end
