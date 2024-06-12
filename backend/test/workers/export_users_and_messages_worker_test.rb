# frozen_string_literal: true

require 'csv'
require 'test_helper'

# test/workers/export_users_and_messages_worker_test.rb
class ExportUsersAndMessagesWorkerTest < ActiveSupport::TestCase
  test 'should create files in tmp folder' do
    execute_and_test
  end

  test 'should create files if there data for user and messages exist' do
    20.times do |i|
      user = User.create(email: "newuser_#{i}@example.com")
      user.messages.create(title: "message #{i}", body: "body #{i}")
    end

    execute_and_test
  end

  test 'should write data correctly in user file' do
    2.times { |i| User.create(email: "newuser_#{i}@example.com") }
    execute_and_test

    file_content = csv_contents(file_name('users'))
    assert_equal file_content.count, 3 # 2 users, 1 header

    headers = file_content.shift.map(&:strip)
    assert_equal ExportUsersAndMessagesWorker::USER_HEADERS, headers

    # check all users
    User.all.each_with_index do |user, i|
      assert_equal user.id.to_s, file_content[i][0]
      assert_equal user.created_at.to_s, file_content[i][1]
      assert_equal user.email, file_content[i][2]
      assert_equal user.json_web_token, file_content[i][3]
    end
  end

  test 'should write data correctly in message file' do
    user = User.create(email: 'newuser@example.com')
    5.times { |i| user.messages.create(title: "message #{i}", body: "body #{i}") }

    execute_and_test

    file_content = csv_contents(file_name('messages'))
    assert_equal file_content.count, 6 # 5 messages, 1 header

    headers = file_content.shift.map(&:strip)
    assert_equal ExportUsersAndMessagesWorker::MESSAGE_HEADERS, headers

    # check all messages
    user.messages.each_with_index do |message, i|
      assert_equal message.id.to_s, file_content[i][0]
      assert_equal message.created_at.to_s, file_content[i][1]
      assert_equal message.title, file_content[i][2]
      assert_equal message.body, file_content[i][3]
      assert_equal user.id.to_s, file_content[i][4]
      assert_equal user.email, file_content[i][5]
    end
  end

  def execute_and_test
    ExportUsersAndMessagesWorker.new.perform

    assert file_exists('users')
    assert file_exists('messages')
  end

  def file_exists(entity)
    Rails.root.join('tmp', file_name(entity)).exist?
  end

  def csv_contents(name)
    CSV.read(Rails.root.join('tmp', name))
  end

  def file_name(entity)
    "new_#{entity}_#{Time.zone.now.strftime('%Y%m%d')}.csv"
  end
end
