class Devise::SessionsController < DeviseController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => :create
  prepend_before_filter { request.env["devise.skip_timeout"] = true }
  skip_before_filter :verify_authenticity_token
  respond_to :html ,:json,:xml

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  # POST /resource/sign_in
  #def create
  #  self.resource = warden.authenticate!(auth_options)
  #  set_flash_message(:notice, :signed_in) if is_navigational_format?
  #  sign_in(resource_name, resource)
  #  respond_with resource, :location => after_sign_in_path_for(resource)
  #end
  def create
    user_email = User.find_by_email(resource_params['email'])
    puts "user_email:::::::::::::#{user_email.inspect}"
    puts "password::::::::::::#{resource_params['password']}"
    if user_email
      if (user_email.status == "Verified" || user_email.status == nil)
        puts "status:::::::#{user_email.status}"
        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
        sign_in(resource_name, resource)
        set_flash_message(:notice, :signed_in) if is_navigational_format?
        respond_with({:success => true , :email => resource_params['email'],:password =>resource_params['password'],:members => current_user.members.sort_by {|m| m.name.downcase}},:location => root_url)
      else
        flash[:notice] = "User Not Active"
        redirect_to sign_in_path
      end
    else
      flash[:notice] = "Email/Password doesn't match"
      redirect_to sign_in_path
    end

    # return render :json => { :success => true, :username => current_user.username }
  end

  def failure
    # return render:json => {:success => false, :username => resource_params['username']}
    respond_with({:success => false , :username => nil}, :location => root_url)
  end

  # DELETE /resource/sign_out
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

  protected

  def sign_in_params
    devise_parameter_sanitizer.for(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { :methods => methods, :only => [:password] }
  end

  def auth_options
    { :scope => resource_name, :recall => "#{controller_path}#new" }
  end
end
