class MembersController < ApplicationController
  # GET /members
  # GET /members.json
  respond_to :html, :json

  skip_before_filter :verify_authenticity_token

  def index
    @members = Member.order("id asc").all
    respond_with(@member)
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @members }
    #end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member = Member.find(params[:id])
    respond_with(@member)
  end

  # GET /members/new
  # GET /members/new.json
  def new
    @member = current_user.members.build
    respond_with(@member)
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(params[:member])
    if params[:member][:user_id] != nil
      @usr = User.find(params[:member][:user_id])
      @member.user_id = params[:member][:user_id]
    else
      @member.user_id = current_user.id
    end

    respond_with(@member) do |format|
      if @member.save
        if @member.avatar_file_name != nil
          @member.image_url= @member.avatar.url(:medium)
        else
          @member.image_url= nil
        end
        @member.save
        if @usr
          @usr.members.each do |m|
            if m.id != @member.id
              old_member_contact = m.user_contacts.build(:contact_id => @member.id)
              old_member_contact.save
              new_member_contact = @member.user_contacts.build(:contact_id => m.id)
              new_member_contact.save
            else
              old_member_contact = m.user_contacts.build(:contact_id => @member.id)
              old_member_contact.save
            end
          end
          @link = family_lists_path
        else
          current_user.members.each do |m|
            if m.id != @member.id
              old_member_contact = m.user_contacts.build(:contact_id => @member.id)
              old_member_contact.save
              new_member_contact = @member.user_contacts.build(:contact_id => m.id)
              new_member_contact.save
            else
              old_member_contact = m.user_contacts.build(:contact_id => @member.id)
              old_member_contact.save
            end
          end
          @link = root_url
        end
        system "rake image_load:for_each_membernew  resource=#{@member.id}&"
        format.html { redirect_to @link, notice: 'New member was successfully added.' }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { render action: "new" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end

    #if @member.save
    #      @member.image_url= @member.avatar.url(:small)
    #      @member.save
    #      system "rake image_load:for_each_member  resource=#{@member.id}&"
    #      flash[:notice] = "Member was successfully created."
    #      respond_with(@member, :location => root_url)
    #    else
    #      format.html { render action: "new" }
    #      format.json { render json: @member.errors, status: :unprocessable_entity }
    #    end

  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    @member = Member.find(params[:id])

    respond_with(@member) do |format|
      if @member.update_attributes(params[:member])
        if @member.avatar
          if @member.avatar_file_name != nil
            @member.update_attribute(:image_url, @member.avatar.url(:medium))
          else
            @member.update_attribute(:image_url, nil)
          end
        end
        if current_user.id == @member.user_id
          format.html { redirect_to root_url, notice: 'Member was successfully updated.' }
        else
          format.html { redirect_to family_lists_path, notice: 'Member was successfully updated.' }
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member = Member.find(params[:id])
    @user = User.find(@member.user_id)
    if @user.members.count > 1
       @member.destroy
    else
      @user.destroy
    end
    respond_with(@member) do |format|
      format.html { redirect_to root_url, notice: 'Member was successfully deleted.'  }
      format.json { head :no_content }
    end


  end

  def update_members
    puts "::::::::::MEMBERS CONTROLLER - UPDATE_MEMBERS:::::::::"
    puts "params:::::::::#{params[:fileid].headers.inspect}"
    puts "params:::email:::::::::#{params[:email]}"
    puts "params:::firstname:::::::::#{params[:firstname]}"
    puts "params:::lastname:::::::::#{params[:lastname]}"
    user = User.find_by_email(params[:email])

    if params[:admin]
      puts "user::::::::::#{user.inspect}"
      @member = user.members[0]
      puts "member::::::::::#{@member.inspect}"
      @member.avatar = params[:fileid]
      @member.first_name = params[:firstname]
      @member.name = params[:lastname]
      @member.relationship = "Admin"
      puts "@member.avatar::::::::::#{@member.avatar.inspect}"
      #member.image_url = member.avatar
      #puts "member.image_url::::::::#{@member.image_url.inspect}"
      @member.save(:validate => false)
      @member.update_attribute(:image_url, @member.avatar.url)
      puts "After save member::::::::::#{@member.inspect}"
    else
      puts "::::::::::::::::IN ELSE:::::::::::"
      @member = user.members.build
      @member.avatar = params[:fileid]
      @member.relationship = "Member"
      @member.first_name = params[:firstname]
      @member.name = params[:lastname]
      #@member.image_url = @member.avatar
      #puts "@member.image_url::::::::#{@member.image_url.inspect}"
      @member.save(:validate => false)
      @member.update_attribute(:image_url, @member.avatar.url)
    end
    user.members.each do |m|
      if m.id != @member.id
        old_member_contact = m.user_contacts.build(:contact_id => @member.id)
        old_member_contact.save
        new_member_contact = @member.user_contacts.build(:contact_id => m.id)
        new_member_contact.save
      else
        old_member_contact = m.user_contacts.build(:contact_id => @member.id)
        old_member_contact.save
      end
    end
    respond_with @member
  end

  def delete_family_member
    @member = Member.find(params[:family_member])
    @user = User.find(@member.user_id)
    if @user.members.count > 1
      @member.destroy
    else
      @user.destroy
    end
    flash[:notice] = 'Member was successfully deleted.'
    respond_with(@member, :location => family_lists_path)
  end

  def edit_family_member
    @family_member = Member.find(params[:id])
    render :layout=>false
  end

  def add_member
    usr = User.find(params[:id])
    @new_member = usr.members.build
    @user_mem = usr.id
    #respond_with(@new_member)
    render :layout=>false
  end

end
