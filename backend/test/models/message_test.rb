require "test_helper"

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
    message1 = user.messages.create(title: 'message1', body: 'first message')

    assert_respond_to message1, :user
  end
end
