class UsersController < ApplicationController

	helper_method :resource_user, :users_collection, :semesters_collection

	before_action :require_user, only: [:show, :all]
	before_action :require_admin, only: [:all, :create, :new, :destroy, :update]

	def show
		redirect_to admin_panel_path if resource_user.admin?
	end

	def new
	end

	def all			
	end

	def create 
	  @user = User.new(user_params)
	  if @user.valid? && password_confirmed? && unique_user?
	  	@user.save
	  	redirect_to admin_panel_path
	  else 
	    render :new
	  end 
	end

	def destroy
		resource_user.destroy
		redirect_to admin_panel_path
	end

	def update
	end

	private

	def resource_user
		@resource_user ||=
			if current_user.admin?
					if params[:id].nil?
						current_user
					else
						User.find(params[:id])
					end
				else
					User.find(session[:user_id])
			end
	end

	def semesters_collection
		@semesters_collection ||= resource_user.semesters
	end

	def users_collection
		@users_collection ||= User.all
	end

	def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def unique_user? 	
  	!User.exists?(email: params[:user][:email])
  end

  def password_confirmed?
  	params[:user][:password] == params[:user][:password_confirmation]
  end

end