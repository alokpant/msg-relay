# frozen_string_literal: true

# app/mailers/export_users_and_messages_mailer.rb
class ExportUsersAndMessagesMailer < ApplicationMailer
  default from: 'no-reply@gmail.com'

  def perform
    users_file = params[:users_file]
    messages_file = params[:messages_file]
    timestamp = Time.zone.today

    attachments["new_users_#{timestamp}.csv"] = File.read(users_file)
    attachments["new_messages_#{timestamp}.csv"] = File.read(messages_file)

    mail(to: 'justtodesign@gmail.com', subject: "#{timestamp} - Export of New Users and Messages") do |format|
      format.html
      format.text
    end
  end
end
