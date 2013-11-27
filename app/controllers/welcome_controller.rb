class WelcomeController < ApplicationController
	def index
		p session
		@user = User.new
		@users = User.all
		gon.users = User.all
		gon.current_user = session[:user_id]
	end

	def create
		@user = User.create(params[:user])
	end

	def update
		p session
		@user = User.find(params[:user_id])
		@user.lat = params[:latitude]
		@user.long = params[:longitude]
		@user.save!
	end

	def login
		p params
		@user = User.find_by_username(params[:user][:username])
		p @user
		if @user && @user.authenticate(params[:user][:password])
				session[:user_id] = @user.id
				redirect_to '/'
		else
			p "stupid"
		end
	end
end
