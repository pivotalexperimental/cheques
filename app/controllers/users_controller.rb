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

    if params[:user][:new_password].blank?
      params[:user].delete(:new_password)
      params[:user].delete(:new_password_confirmation) if params[:user][:new_password_confirmation].blank?
    end

    result = if user.valid_password?(current_password)
      new_attributes = { password: params[:user][:new_password],
                         password_confirmation: params[:user][:new_password_confirmation] }
      user.update_attributes(new_attributes)
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
