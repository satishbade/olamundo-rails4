class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  skip_before_filter :verify_authenticity_token
  respond_to :html, :json

  def index
    #@messages = Message.all
    puts "username :::::::: #{params[:username]}"
    puts "contactname :::::::: #{params[:contactname]}"
    puts "email :::: #{params[:email]}"
    puts "messages count :::: #{params[:count]}"

    @messages_count = 0
    if params[:count]
      @messages_count = params[:count].to_i
    else
      @messages_count = 15
    end

    #find out memeber
    user = User.find_by_email(params[:email])
    sender_id = Member.find_by_name_and_user_id(params[:username],user.id).id
    receiver_id = Member.find_by_name_and_user_id(params[:contactname],user.id).id

    #contact = UserContact.where("member_id = ? AND contact_id = ?",params[:username],params[:contactname])
    sender_contact = UserContact.by_contact(sender_id, receiver_id)

    # message between two members
    #count = contact[0].id
    #count = contact[0].id
    #user = Member.find(params[:username])
    @messages = Array.new
    @old_date == nil
    if sender_contact[0].messages != []
      @messages = sender_contact[0].messages.order('created_at ASC')
      messagesCount =  @messages.count
      @messages.reverse
      @dates = @messages.pluck(:created_at)

      if @messages.count > @messages_count
        puts "sent :::::: #{@messages_count} messages::::::::"
        @messages = @messages.last(@messages_count)
      end

      @sorted_messages = Array.new
      @dates.each do |date|
        @datewise_messages = Hash.new
        selected_dates = Array.new
        @messages.each do |message|
          if date.end_of_day >= message.created_at && date.beginning_of_day <= message.created_at
            selected_dates << message
          end
        end
        if @old_date == nil || date > @old_date.beginning_of_day && date > @old_date.end_of_day
          @datewise_messages["messageCount"] = messagesCount
          @datewise_messages["date"] = date
          @datewise_messages["messages"] = selected_dates
          @datewise_messages["contact_name"] = params[:contactname]
          @sorted_messages << @datewise_messages
        end
        @old_date = date
      end
    end

    #if params[:username] && params[:contactname]
    #  @messages = Message.find_by_sql("select * from messages where message_from in ('#{params[:username]}','#{params[:contactname]}') and message_to in ('#{params[:username]}','#{params[:contactname]}')")
    #end
    #@messages = Message.pluck(:message)

    respond_with @sorted_messages
  end

  def requesting_messages
    #@messages = Message.all
    puts "username :::::::: #{params[:username]}"
    puts "contactname :::::::: #{params[:contactname]}"
    puts "email :::: #{params[:email]}"
    puts "messages count :::: #{params[:count]}"

    @messages_count = 0
    if params[:count]
      @messages_count = params[:count].to_i
    else
      @messages_count = 15
    end

    #find out memeber
    user = User.find_by_email(params[:email])

    @all_messages = Array.new
    user.members.each do |contactName|
      sender_id = Member.find_by_name_and_user_id(params[:username], user.id)
      receiver_id = Member.find_by_name_and_user_id(contactName.name, user.id)

      sender_contact = UserContact.by_contact(sender_id.id, receiver_id.id)

      @messages = Array.new
      @old_date == nil
      if sender_contact[0].messages != []
        @messages = sender_contact[0].messages.order('created_at ASC')
        messagesCount =  @messages.count
        @messages.reverse
        @dates = @messages.pluck(:created_at)

        if @messages.count > @messages_count
          puts "sent :::::: #{@messages_count} messages::::::::"
          @messages = @messages.last(@messages_count)
        end

        @sorted_messages = Array.new
        @dates.each do |date|
          @datewise_messages = Hash.new
          selected_dates = Array.new
          @messages.each do |message|
            if date.end_of_day >= message.created_at && date.beginning_of_day <= message.created_at
              selected_dates << message
            end
          end
          if @old_date == nil || date > @old_date.beginning_of_day && date > @old_date.end_of_day
            @datewise_messages["messageCount"] = messagesCount
            @datewise_messages["date"] = date
            @datewise_messages["messages"] = selected_dates
            @datewise_messages["contact_name"] = contactName.name
            @sorted_messages << @datewise_messages
          end
          @old_date = date
        end
      end
      if @sorted_messages != nil && !@sorted_messages.empty?
        @all_messages << @sorted_messages
      end
    end

    respond_with @all_messages
  end

  def checkUnReadMessages
    @unread_messages = Hash.new
    @unread_messages[:count] = 0
    #@messages = Message.all
    puts "username :::::::: #{params[:username]}"
    puts "contactname :::::::: #{params[:contactname]}"
    puts "email :::: #{params[:email]}"
    puts "type :::: #{params[:type]}"

    @unread_messages[:contactname] = params[:contactname];
    #find out memeber
    user = User.find_by_email(params[:email])
    sender_id = Member.find_by_name_and_user_id(params[:username],user.id).id
    receiver_id = Member.find_by_name_and_user_id(params[:contactname],user.id).id

    sender_contact = UserContact.by_contact(sender_id, receiver_id)

    if sender_contact[0].messages != []
      sender_contact[0].messages.each do |msg|
        if msg.message_type == "received" && msg.read == "No"
          if params[:type] == "check"
            @unread_messages[:count] = @unread_messages[:count] + 1
          else
            msg.read = "Yes"
            msg.save
          end
        end
      end
    end

    @unread_messages[:count] = @unread_messages[:count].to_s
    respond_with @unread_messages
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])
    respond_with @message
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new
    respond_with @message
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  def account_messages
    @user_account = Kaminari.paginate_array(User.where("status = ?", "Verified").order("email asc").all).page(params[:page])
    respond_with @user_account
  end

  def send_log_mail
    UserMailer.message_report.deliver
    redirect_to account_messages_path
  end

end
