# frozen_string_literal: true

# app/workers/export_users_and_messages_worker.rb
class ExportUsersAndMessagesWorker
  include Sidekiq::Worker

  CREATED_AT_FORMAT = '%Y-%m-%d %H:%m'

  CSV_HEADERS = {
    users: ['ID', 'Created At', 'Email', 'JSON Web Token'],
    messages: ['ID', 'Created At', 'Title', 'Body', 'User ID', 'User Email']
  }.freeze

  def perform
    require 'csv'

    generate_csv_files('users')
    generate_csv_files('messages')

    ExportUsersAndMessagesMailer.with(timestamp: timestamp).send_mail.deliver_now
  end

  private

  def generate_csv_files(type)
    file_path = send(:"#{type}_file_path")
    delete_file(file_path)

    add_records_to_csv(type, file_path)
  end

  def users_file_path
    @users_file_path ||= file_path('users')
  end

  def messages_file_path
    @messages_file_path ||= file_path('messages')
  end

  def file_path(name)
    Rails.root.join('tmp', "new_#{name}_#{timestamp}.csv")
  end

  def timestamp
    @timestamp ||= Time.zone.now.strftime('%Y%m%d')
  end

  def delete_file(file_path)
    FileUtils.rm([file_path]) if File.exist?(file_path)
  end

  def add_records_to_csv(type, file_path)
    CSV.open(file_path, 'wb') do |csv|
      csv << CSV_HEADERS[type.to_sym]
      send(:"add_#{type}_records", csv)
    end
  end

  def add_users_records(csv)
    User.where(created_at: Time.zone.now.beginning_of_day..).find_each do |user|
      csv << [user.id, user.created_at.strftime(CREATED_AT_FORMAT), user.email, user.json_web_token]
    end
  end

  def add_messages_records(csv)
    Message.where(created_at: Time.zone.now.beginning_of_day..)
      .includes(:user)
      .order(:user_id)
      .find_each do |message|
        csv << [message.id, message.created_at.strftime(CREATED_AT_FORMAT), message.title, message.body, message.user.id, message.user.email]
      end
  end
end
