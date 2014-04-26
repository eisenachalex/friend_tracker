class WelcomeController < ApplicationController
	def index
		@user = User.new
		@users = User.all

	end

	def create
		p params
		@user = User.create(params[:user])
		session[:user_id] = @user.id
	end


	def update
		p params
		p session
	#	@user = User.find(params[:user_id])
		@lat = params[:latitude]
		@long = params[:longitude]
	#	@user.save!
	end

	def login
		p params
		@user = User.find_by_username(params[:user][:username])
		p @user
		if @user && @user.authenticate(params[:user][:password])
				session[:user_id] = @user.id
		else
			p "login_failed"
		end
	end

	def map
		p session[:user_id]
			gon.users = User.all
		gon.current_user = session[:user_id]
	end
end
