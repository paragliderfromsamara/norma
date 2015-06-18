class AdminToolsController < ApplicationController
  def admin_entry
  end

  def sign_up
	@user = User.new 
  end

  def create_user
		@user = User.new(params[:user])
		respond_to do |format|
		  if @user.save
			user = User.authenticate(params[:user][:name],
									params[:user][:password])
			sign_in user
			format.html { redirect_to root, :notice => 'Пользователь был успешно создан' }
			format.json { render :json => @user, :status => :created, :location => @user }
		  else
			format.html { render :action => "/sign_up" }
			format.json { render :json => @user.errors, :status => :unprocessable_entity }
		  end
		end
  end
  
  def user_update
  end
end
