class ApnsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /ipad_devises
  # GET /ipad_devises.json
  respond_to :html, :json

  def index

  end

  def new
    puts "from :::: #{params[:from]}"
    puts "to :::: #{params[:to]}"
    puts "message ::::: #{params[:message]}"
    if params[:from] && params[:to]
      member = Member.find_by_name(params[:to])
      if member
        puts "member_name:::: #{member.inspect}"
        ipad_devise = IpadDevise.find_by_member_id(member.id)
        puts "ipad_devise--:::: #{ipad_devise.inspect}"
        pusher = Grocer.pusher(certificate: "#{Rails.root}/ProductionCertificates.pem")
        #pusher = Grocer.pusher(certificate: "#{Rails.root}/certificate.pem")

        notification = Grocer::Notification.new(
            #device_token: "8a6ff6f223facd52d7a98ffe16d3c14d63d7fec32a99b7780ff5967247e17a52",
            device_token: ipad_devise.devise_token,
            alert:        "You got a message from #{params[:from]}",
            badge:        1
        )

        pusher.push(notification)
      end
    end
  end

  def create
    puts "We are in create method in apns controller"

    puts "Data :::::::::: #{params[:data].inspect}"
    puts "After ::::::::"

    puts "from :::: #{params[:from]}"
    puts "to :::: #{params[:to]}"
    puts "email :::: #{params[:email]}"

    #find out memebers
    user = User.find_by_email(params[:email])

    sender_id = Member.find_by_name_and_user_id(params[:from] ,user.id).id
    receiver_id = Member.find_by_name_and_user_id(params[:to] ,user.id).id

    #find out user_contacts
    if params[:from] == params[:to]
      puts "username and conatctname are same"
      sender_contact = UserContact.by_contact("#{sender_id}","#{receiver_id}")
      #create message using user_contacts
      @message = sender_contact[0].messages.build
      @message.message_time = params[:data][:time]
      @message.message = params[:data].to_json
      @message.receiver_user_contact_id = UserContact.by_contact("#{receiver_id}","#{sender_id}")[0].id
      @message.message_type = "sent"
      @message.read = "Yes"
      @message.message_from = params[:from]
      @message.message_to = params[:to]
      @message.save
    elsif (sender_id != nil && receiver_id != nil)
      puts "username and conatctname are not same"
     sender_contact = UserContact.by_contact("#{sender_id}","#{receiver_id}")
    #create message using user_contacts
      @message = sender_contact[0].messages.build
      @message.message_time = params[:data][:time]
      @message.message = params[:data].to_json
      @message.receiver_user_contact_id = UserContact.by_contact("#{receiver_id}","#{sender_id}")[0].id
      @message.message_type = "sent"
      @message.message_from = params[:from]
      @message.message_to = params[:to]
      @message.save
     receiver_contact = UserContact.by_contact("#{receiver_id}","#{sender_id}")
      @message = receiver_contact[0].messages.build
      @message.message_time = params[:data][:time]
      @message.message = params[:data].to_json
      @message.receiver_user_contact_id = UserContact.by_contact("#{sender_id}","#{receiver_id}")[0].id
      @message.message_type = "received"
      @message.message_from = params[:from]
      @message.message_to = params[:to]
      @message.read = "No"
      @message.save

      user_contact_id = UserContact.where("contact_id != ? and member_id = ?", receiver_id, receiver_id)
      puts "user_contact_id:::::::::::#{user_contact_id.inspect}"
      count = 0

      user_contact_id.each do |user_contact|
        count = count + user_contact.messages.where(:message_type => "received", :read => "No").count
        puts "count::::::#{count}"
      end

      member = Member.find_by_name_and_user_id(params[:to],user.id)
      if member
        puts "member_name:::: #{member.inspect}"
        ipad_devise = IpadDevise.find_by_member_id(member.id)
        puts "ipad_devise--:::: #{ipad_devise.inspect}"
        pusher = Grocer.pusher(certificate: "#{Rails.root}/ProductionCertificates.pem")
        #pusher = Grocer.pusher(certificate: "#{Rails.root}/certificate.pem")

        notification = Grocer::Notification.new(
            #device_token: "8a6ff6f223facd52d7a98ffe16d3c14d63d7fec32a99b7780ff5967247e17a52",
            device_token: ipad_devise.devise_token,
            alert:        "You got a message from #{params[:from]}",
            badge:        1,
            sound:        "siren.aiff",
            custom: {:message => {:from => params[:from]}}
        )
        puts notification.inspect
        pusher.push(notification)
      end

    end

    respond_with @message
    #@message = Message.new
    #@message.message_from = params[:from]
    #@message.message_to = params[:to]
    #@message.message_time = params[:data][:time]
    #@message.message = params[:data].to_json

    #puts "message before save:::::::::::::: #{@message.inspect}"
    #@message.save
    #puts "message after save:::::::::::::: #{@message.inspect}"
  end

end