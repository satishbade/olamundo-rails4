class IpadDevisesController < ApplicationController
  # GET /ipad_devises
  # GET /ipad_devises.json
  skip_before_filter :verify_authenticity_token, :only => [:create, :index]

  def index
    #@ipad_devises = IpadDevise.all

    puts "from :::: #{params[:from]}"
    puts "to :::: #{params[:to]}"
    puts "message ::::: #{params[:message]}"
    if params[:from] && params[:to]
      member = Member.find_by_name(params[:to])
      if member
        puts "member_name:::: #{member.inspect}"
        ipad_devise = IpadDevise.find_by_member_id(member.id)
        puts "ipad_devise--:::: #{ipad_devise.inspect}"
        pusher = Grocer.pusher(certificate: "#{Rails.root}/certificate_production.pem")
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

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @ipad_devises }
    #end
  end

  # GET /ipad_devises/1
  # GET /ipad_devises/1.json
  def show
    @ipad_devise = IpadDevise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ipad_devise }
    end
  end

  # GET /ipad_devises/new
  # GET /ipad_devises/new.json
  def new
    @ipad_devise = IpadDevise.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ipad_devise }
    end
  end

  # GET /ipad_devises/1/edit
  def edit
    @ipad_devise = IpadDevise.find(params[:id])
  end

  # POST /ipad_devises
  # POST /ipad_devises.json
  def create
    @ipad_devise = IpadDevise.new(params[:ipad_devise])

    puts "device ---- before -----:::::::::: #{params[:ipad_devise].inspect}"
    puts "device token ---- before -----:::::::::: #{@ipad_devise.devise_token}"
    @ipad_devise.devise_token = @ipad_devise.devise_token[12..@ipad_devise.devise_token.length]
    puts "device token ---- after -----:::::::::: #{@ipad_devise.devise_token}"
    puts "member_name:::: #{params[:member_name]}"
    puts "email :::: #{params[:email]}"

    user = User.find_by_email(params[:email])

    if params[:member_name] && user && @ipad_devise.devise_token
      puts "check for old reference of devise ::::::::"
      devise = IpadDevise.find_by_devise_token(@ipad_devise.devise_token)
      if devise
        puts "added devse is deleting ::::::::"
        devise.destroy
      end
      member = Member.find_by_name_and_user_id(params[:member_name],user.id)
      if member
        #cheking for existing devise
        ipad_devise = IpadDevise.find_by_member_id(member.id)
        if ipad_devise
          if ipad_devise.devise_token != @ipad_devise.devise_token
            puts "devise found ::::::::"
            ipad_devise.destroy
            puts "devise destroyed ::::::::"
            puts "creating devise ::::::::"
            @ipad_devise.member_id = member.id
            @ipad_devise.save
            puts "new devise added ::::::::"
          else
            puts "do nothing"
          end
        else
          puts "creating devise ::::::::"
          @ipad_devise.member_id = member.id
          @ipad_devise.save
          puts "new devise added ::::::::"
        end
      end
    end

    respond_to do |format|
      if true
        format.html { redirect_to @ipad_devise, notice: 'Ipad devise was successfully created.' }
        format.json { render json: @ipad_devise, status: :created, location: @ipad_devise }
      else
        format.html { render action: "new" }
        format.json { render json: @ipad_devise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ipad_devises/1
  # PUT /ipad_devises/1.json
  def update
    @ipad_devise = IpadDevise.find(params[:id])

    respond_to do |format|
      if @ipad_devise.update_attributes(params[:ipad_devise])
        format.html { redirect_to @ipad_devise, notice: 'Ipad devise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ipad_devise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ipad_devises/1
  # DELETE /ipad_devises/1.json
  def destroy
    @ipad_devise = IpadDevise.find(params[:id])
    @ipad_devise.destroy

    respond_to do |format|
      format.html { redirect_to ipad_devises_url }
      format.json { head :no_content }
    end
  end
end
