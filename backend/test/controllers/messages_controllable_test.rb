# frozen_string_literal: true

require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test 'should return empty array when no message exist' do
    get messages_url, as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response, []
  end

  test 'should return all messages if param does not include user_id' do
    5.times do |i|
      user = User.create(email: "newuser#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end

    get messages_url, as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response.length, 5
  end

  test 'should return empty array if user does not have any messages' do
    user = User.create(email: 'newuser@example.com')
    user.messages.create(title: 'first message', body: 'first body')

    user1 = User.create(email: 'seconduser@example.com')
    get messages_url, params: { user_id: user1.id }
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response, []
  end

  test 'should return empty array if user does not exist' do
    user = User.create(email: 'newuser@example.com')
    user.messages.create(title: 'first message', body: 'first body')

    get messages_url, params: { user_id: 20 }
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response, []
  end

  test 'should return record for user if params includes user_id' do
    5.times do |i|
      user = User.create(email: "newuser#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end

    last_user_id = User.last.id
    get messages_url, params: { user_id: last_user_id }
    assert_response :success

    json_response = JSON.parse(@response.body)[0]
    assert_equal json_response['user_id'], last_user_id
  end

  test 'should return only response indicated by limit' do
    20.times do |i|
      user = User.create(email: "newuser#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end
    size = 3

    get messages_url, params: { limit: size }
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal json_response.length, size
  end

  test 'should return 10 response if no limit is present in params' do
    20.times do |i|
      user = User.create(email: "newuser#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end

    get messages_url, as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response.length, 10
  end

  test 'should show message if present' do
    20.times do |i|
      user = User.create(email: "newuser#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end

    last_message = Message.last
    get message_url(last_message), as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response['id'], last_message.id
  end

  test 'should raise error if message is not present' do
    2.times do |i|
      user = User.create(email: "newuser#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end
    get message_url(9999), as: :json

    assert_response :not_found
    json_response = JSON.parse(@response.body)
    assert_equal('Not Found', json_response['error'])
  end
end
