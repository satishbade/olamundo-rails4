class Devise::RegistrationsController < DeviseController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  # GET /resource/sign_up
  def new
    #build_resource({})
    #respond_with self.resource
    resource = build_resource({})
    1.times do
      member = resource.members.build
    end
    respond_with resource
  end

  # POST /resource
  #def create
  #  build_resource(sign_up_params)
  #
  #  if resource.save
  #    if resource.active_for_authentication?
  #      set_flash_message :notice, :signed_up if is_navigational_format?
  #      sign_up(resource_name, resource)
  #      respond_with resource, :location => after_sign_up_path_for(resource)
  #    else
  #      set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
  #      expire_session_data_after_sign_in!
  #      respond_with resource, :location => after_inactive_sign_up_path_for(resource)
  #    end
  #  else
  #    clean_up_passwords resource
  #    respond_with resource
  #  end
  #end

  def create
    build_resource
    #puts "params -- resource -- email:::::::: #{params[:resource][:email]}"
    existing_user = User.where(:email => resource.email).first
    #existing_user = User.first{({:conditions => ({:email => resource.email})})}
    puts "resource -- email:::::::: #{resource.email}"
    puts "resource -- params -- email:::::::: #{params[:user][:email]}"
    puts "existing_user ::::::: #{existing_user.inspect}"
    #existing_user = User.find_by_email(resource.email)

    #if existing_user && (existing_user.where(:status => "Inactive"))
    if existing_user && existing_user.status == "Inactive"
      UserMailer.verify_code(existing_user).deliver
      respond_with({:user => existing_user, :member => existing_user.members.first}, :location => verify_account_path, notice: "Please enter the verification code here which has been sent to your mail id.")
      return
    end

    #code = rand(36**6).to_i(36)[0..3]
    code = rand(1000..9999)
    resource.verification_code = code
    resource.status = "Inactive"
    resource.email = params[:user][:email]
    #resource.password =  params[:user][:password]
    puts "params[:user][:password] :::: #{params[:user][:password]}"
    puts "resource.password :::: #{resource.password}"
    resource[:password] =  params[:user][:password]
    #resource[:password_confirmation] =  params[:user][:password]

    puts "resource :::::: #{resource.inspect}"
    if resource.save
      puts "resource.email::::#{resource.email.inspect}"
      UserMailer.verify_code(resource).deliver
      @member = Member.find_by_user_id(resource.id)
      if @member.avatar
        @member.image_url = @member.avatar.url(:medium)
      end
      @member.save

      old_member_contact = @member.user_contacts.build(:contact_id => @member.id)
      old_member_contact.save

      puts @name = @member.name
      #system "rake image_load:for_each_membernew  resource=#{@member.id} --trace&"
      #if resource.active_for_authentication?
      #  set_flash_message :notice, :signed_up if is_navigational_format?
      #  sign_up(resource_name, resource)
      #  respond_with resource, :location => after_sign_up_path_for(resource)
      #else
      #  set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
      #  expire_session_data_after_sign_in!
      #  respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      #end
      #redirect_to sign_in_path ,notice: "Welcome! #{ @name } You have signed up successfully."
      #redirect_to verify_account_path ,notice: "Please enter the verification code here which has been sent to your mail id."
      respond_with({:user => resource, :member => @member}, :location => verify_account_path, notice: "Please enter the verification code here which has been sent to your mail id.")
    else
      clean_up_passwords resource
      #1.times do
      #  member = resource.members.build
      #end
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_with_password(account_update_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def verify_account
    puts "VERIFICATION_CODE:::::#{params[:verification_code].inspect}"
    if params[:verification_code]
      user = User.find_by_verification_code(params[:verification_code].to_s)
      if user
        puts "user::::::::::#{user.inspect}"
        puts "member:::::::::#{user.members.inspect}"
        if user.verification_code == params[:verification_code]
          user.update_attribute(:status, "Verified")
          user.update_attribute(:verification_code, nil)
          flash[:notice] = "Welcome! #{ user.members.name } You have signed up successfully."
          respond_with({:user => user, :member => user.members[0]}, :location => sign_in_path)
          #respond_with({:success => true , :email => user.email, :password => user.password, :members => user.members}, :location => sign_in_path)
        end
      else
        flash[:notice] = "Verification Code does not match. Please enter the correct code."
        respond_with({:errors => "Verification Code does not match"}, :location => verify_account_path)
        #respond_with({:errors => "Verification Code does not match"}, :location => verify_account_path)
      end
    end
  end

  def resend_verification_code
    puts "params[:email]::::::::::::#{params[:email].inspect}"

    if params[:email]
      user = User.find_by_email(params[:email])
      puts "user::::::::::#{user.inspect}"
      if user
        if user.status == "Inactive"
          #code = rand(36**6).to_s(36)[0..3]
          code = rand(1000..9999)
          if user.email == params[:email]
            #user.update_attribute(:status, "Inactive")
            user.update_attribute(:verification_code, code)
            UserMailer.verify_code(user).deliver
            flash[:notice] = "Verification code successfully sent."
            if params[:confirm]
              redirect_to family_lists_path
            else
              respond_with(user, :location => sign_in_path)
            end
          else
            flash[:notice] = "Email does not match. Please enter the correct email."
            respond_with(user, :location => verify_account_path)
          end
        end
      end
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    devise_parameter_sanitizer.for(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.for(:account_update)
  end

  #def resource_params
  #  params.require(:user).permit(:name, :email, :password, :password_confirmation, :members_attributes) # And whatever other params you need
  #end
  #private :resource_params

end
