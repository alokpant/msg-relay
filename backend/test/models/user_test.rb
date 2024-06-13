# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id             :bigint           not null, primary key
#  email          :string           not null
#  json_web_token :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'test_helper'

# test/models/user_test.rb:
class UserTest < ActiveSupport::TestCase
  test 'email should be present' do
    user = User.new

    assert_not user.save, 'Saved user without a name'
  end

  test 'email should have proper format' do
    user = User.new(email: 'a.b')

    assert_not user.save, 'Saved user with incorrect format'
  end

  test 'email should be unique and case-insensitive' do
    User.create(email: 'test@foo.com')
    new_user = User.new(email: 'Test@foo.com')

    assert_not new_user.save, 'Saved user with a non-unique email'
  end

  test 'json_web_token should be populated automatically' do
    user = User.create(email: 'test@foo.com')

    assert_not_nil user.json_web_token, 'json_web_token should be generated automatically'
  end

  test 'should not update json_web_token to an empty field' do
    user = User.create(email: 'test@foo.com')

    assert_raises(ActiveRecord::RecordNotSaved) do
      user.update!(json_web_token: '')
    end
  end

  test 'should have many message' do
    user = User.create(email: 'test@foo.com')

    assert_respond_to user, :messages
  end

  test 'all messages related to user should be destroyed, when user is destroyed' do
    user = User.create(email: 'test@foo.com')

    user.messages.create(title: 'message1', body: 'first message')
    user.messages.create(title: 'message2', body: 'second message')

    assert_difference('Message.count', -2) do
      user.destroy
    end
  end
end
