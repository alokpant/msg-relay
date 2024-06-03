# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

# test/models/message_test.rb
class MessageTest < ActiveSupport::TestCase
  test 'title should be present' do
    user = User.create(email: 'test@foo.com')
    message = user.messages.new(title: 'Message title')

    assert_not message.save, 'Saved message without a title'
  end

  test 'body should be present' do
    user = User.create(email: 'test@foo.com')
    message = user.messages.new(body: 'Message body')

    assert_not message.save, 'Saved message without a body'
  end

  test 'should not be valid without a user' do
    message = Message.new(title: 'Message title', body: 'Message body')

    assert_not message.save, 'Saved message with missing user'
  end

  test 'should belong to user' do
    user = User.create(email: 'test@foo.com')
    message_1 = user.messages.create(title: 'message_1', body: 'first message')

    assert_respond_to message_1, :user
  end
end
