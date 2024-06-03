# frozen_string_literal: true

require 'test_helper'

# test/controllers/messages_controllable_test.rb
class MessagesControllerTest < ActionDispatch::IntegrationTest
  # INDEX method - Start #
  test 'should return empty array when no message exist' do
    user = User.create(email: "newuser@example.com")
    get messages_url,
      headers: { 'Authorization' => user.json_web_token }
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response, []
  end

  test 'should return all messages if param does not include user_id' do
    5.times do |i|
      user = User.create(email: "newuser_#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end

    get messages_url,
      headers: { 'Authorization' => User.last.json_web_token }

    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response.length, 5
  end

  test 'should return record for user if params includes user_id' do
    5.times do |i|
      user = User.create(email: "newuser_#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end

    last_user_id = User.last.id
    get messages_url,
      params: { user_id: last_user_id },
      headers: { 'Authorization' => User.last.json_web_token }

    assert_response :success

    json_response = JSON.parse(@response.body)[0]
    assert_equal json_response['user_id'], last_user_id
  end

  test 'should return empty array if user does not have any messages' do
    user = User.create(email: 'newuser@example.com')
    user.messages.create(title: 'first message', body: 'first body')

    user1 = User.create(email: 'seconduser@example.com')
    get messages_url,
      params: { user_id: user1.id },
      headers: { 'Authorization' => user.json_web_token }

    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response, []
  end

  test 'should return empty array if user does not exist' do
    user = User.create(email: 'newuser@example.com')
    user.messages.create(title: 'first message', body: 'first body')

    get messages_url,
      params: { user_id: 20 },
      headers: { 'Authorization' => user.json_web_token }

    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response, []
  end

  test 'should return only response indicated by limit' do
    20.times do |i|
      user = User.create(email: "newuser_#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end
    size = 3

    get messages_url,
      params: { limit: size },
      headers: { 'Authorization' => User.last.json_web_token }

    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal json_response.length, size
  end

  test 'should return 10 response if no limit is present in params' do
    20.times do |i|
      user = User.create(email: "newuser_#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end

    get messages_url,
      headers: { 'Authorization' => User.last.json_web_token }
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response.length, 10
  end
  # INDEX method - end #

  # SHOW method - Start #
  test 'should show message if present' do
    20.times do |i|
      user = User.create(email: "newuser_#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end

    last_message = Message.last
    get message_url(last_message),
      headers: { 'Authorization' => User.last.json_web_token }
    
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response['id'], last_message.id
  end
  # SHOW method - end #

  # CREATE method - Start #
  test 'should create message' do
    user = User.create(email: 'newuser@example.com')

    assert_difference('Message.count') do
      post messages_url,
           params: {
             message: {
               title: 'New Title',
               body: 'New Body'
             },
             user_id: user.id
           },
           headers: { 'Authorization' => user.json_web_token },
           as: :json
    end
    assert_response :created

    json_response = JSON.parse(@response.body)
    assert_equal json_response['user_id'], user.id
  end

  test 'should not create message without authentication' do
    post messages_url,
         params: {
           message: {
             title: 'New Title',
             body: 'New Body'
           }
         },
         as: :json

    assert_response :unauthorized
    json_response = JSON.parse(@response.body)
    assert_equal('Unauthorized', json_response['error'])
  end
  # CREATE method - End #

  # UPDATE method - Start #
  test 'should update message' do
    user = User.create(email: 'newuser@example.com')
    message = user.messages.create(title: 'New Title', body: 'New body')

    put message_url(message.id),
        params: {
          message: {
            title: 'New Title 2',
            body: 'New Body 2'
          },
        },
        headers: { 'Authorization' => user.json_web_token },
        as: :json

    assert_response :ok

    json_response = JSON.parse(@response.body)
    assert_equal json_response['user_id'], user.id
    assert_equal json_response['title'], 'New Title 2'
    assert_equal json_response['body'], 'New Body 2'
  end

  test 'should not update message if message does not belong to the user' do
    user = User.create(email: 'newuser@example.com')
    message = user.messages.create(title: 'New Title', body: 'New body')
    user1 = User.create(email: 'newuser2@example.com')

    put message_url(message.id),
        params: {
          message: {
            title: 'New Title 2',
            body: 'New Body 2'
          },
        },
        headers: { 'Authorization' => user1.json_web_token },
        as: :json

    assert_response :not_found
    json_response = JSON.parse(@response.body)
    assert_equal('Not Found', json_response['error'])
  end

  test 'should not update message without authentication' do
    user = User.create(email: 'newuser@example.com')
    message = user.messages.create(title: 'New Title', body: 'New body')

    put message_url(message.id),
        params: {
          message: {
            title: 'New Title 2',
            body: 'New Body 2'
          },
        },
        as: :json

    assert_response :unauthorized
    json_response = JSON.parse(@response.body)
    assert_equal('Unauthorized', json_response['error'])
  end
  # UPDATE method - End #
end
