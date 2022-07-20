class Api::V1::RegistrationsController < Devise::RegistrationsController
skip_before_action :verify_authenticity_token

 def create
	if params[:user][:email].nil?
	  render :status => 400, :json => {:message => 'User request must contain the user email.'} and return
	elsif params[:user][:password].nil?
	  render :status => 400, :json => {:message => 'User request must contain the user password.'} and return
	end
	if params[:user][:email]
	  duplicate_user = User.find_by_email(params[:user][:email])
	  unless duplicate_user.nil?
	   render :status => 409, :json => {:message => 'Duplicate email. A user already exists with that email address.'} and return
	  end
	end
	@user = User.create(sign_up_params)
	if @user.save
	  respond_with @user
	else
	  render :status => 400, :json => {:message => @user.errors.full_messages}
	end
 end

private

def sign_up_params
  params.require(:user).permit(:name, :mobile_number, :email, :password, :password_confirmation)
end

def respond_with(resource, _opts = {})
  register_success && return if resource.persisted?
  register_failed
end

def register_success
  render json: { status: 200, user: @user, message: 'Signed up sucessfully.' }
end

def register_failed
 render json: { :status => 500, message: 'Something went wrong.' }
end

end