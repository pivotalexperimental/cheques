class UsersController < ApplicationController

  respond_to :html

  def edit
    @user = current_user
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    user = current_user
    current_password = params[:user].delete(:current_password)

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
    end

    result = if user.valid_password?(current_password)
      user.update_attributes(params[:user])
    else
      user.attributes = params[:user]
      user.valid?
      user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    if result
      sign_in :user, user, :bypass => true
      redirect_to root_path, notice: "Password successfully updated"
    else
      @user = user
      render 'edit'
    end

  end

end
