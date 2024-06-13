# frozen_string_literal: true

# app/mailers/export_users_and_messages_mailer.rb
class ExportUsersAndMessagesMailer < ApplicationMailer
  default from: 'no-reply@gmail.com'

  def send_mail
    require 'fileutils'

    timestamp = params[:timestamp]
    users_file_url = file_path('users', timestamp)
    messages_file_url = file_path('messages', timestamp)
    attachments["new_users_#{timestamp}.csv"] = File.read(users_file_url)
    attachments["new_messages_#{timestamp}.csv"] = File.read(messages_file_url)

    mail(to: 'justtodesign@gmail.com', subject: "#{timestamp} - Export of New Users and Messages")
  end

  private

  def file_path(name, timestamp)
    Rails.root.join('tmp', "new_#{name}_#{timestamp}.csv")
  end
end
