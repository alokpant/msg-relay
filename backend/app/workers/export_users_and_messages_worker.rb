# frozen_string_literal: true

# app/workers/export_users_and_messages_worker.rb
class ExportUsersAndMessagesWorker
  include Sidekiq::Worker

  def perform
    require 'csv'
    require 'fileutils'

    users_file_path = Rails.root.join('tmp', "new_users_#{timestamp}.csv")
    add_users(users_file_path)

    messages_file_path = Rails.root.join('tmp', "new_messages_#{timestamp}.csv")
    add_messages(messages_file_path)

    # setup mailer to send the file to an email or store in cloud
    # ExportUsersAndMessagesMailer.with(users_file: users_file_path, messages_file: messages_file_path).exec.deliver_now
    # FileUtils.rm([users_file_path, messages_file_path])
  end

  private

  def add_users(file_path)
    CSV.open(file_path, 'wb') do |csv|
      csv << ['ID', 'Created At', 'Email', 'JSON Web Token']
      User.where(created_at: Time.zone.now.beginning_of_day..).find_each do |user|
        csv << [user.id, user.created_at, user.email, user.json_web_token]
      end
    end
  end

  def add_messages(file_path)
    CSV.open(file_path, 'wb') do |csv|
      csv << ['ID', 'Created At', 'Title', 'Body', 'User ID', 'User Email']
      Message.where(created_at: Time.zone.now.beginning_of_day..)
        .includes(:user)
        .order(:user_id)
        .find_each do |message|
          csv << [message.id, message.created_at, message.title, message.body, message.user.id, message.user.email]
        end
    end
  end

  def timestamp
    @timestamp ||= Time.zone.now.strftime('%Y%m%d')
  end
end
