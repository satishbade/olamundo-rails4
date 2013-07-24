class UserMailer < ActionMailer::Base

  default :from => "Ola Mundo"
  #:content_type => "text/enriched"

  def welcome_email(email_from_script )
    email = email_from_script
    #attachments['message_report.txt'] = File.read('message_report.txt')
    mail(:to => email,  :subject => "Ola Mundo messages analysis report dated - #{Date.today}") do |format|
      #format.text
      format.html
      end

  end

  def verify_code(user)
    @user = user
    @code = user.verification_code
    puts "email:::::::::#{user.email.inspect}"
    mail(:to => user.email,  :subject => "Verification Code") do |format|
      format.html
    end
  end

  def message_report
    #@user = user
    mail(:to => "ofir@olamundo.com",  :subject => "Message Analysis") do |format|
      format.html
    end
  end


end
