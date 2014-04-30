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

	def current_user
		@user = User.where(username: params[:username]).first
		render :json => {user: @user.username, is_active: @user.is_active}
	end

	def is_active
		@user = User.where(username: params[:username]).first
		if params[:active] == "yes"
			@user.is_active = true
			p "jownts"
		else
			@user.is_active = false
			p "no jownts"
		end
		@user.save!
	end

	def friends
		@users = User.all
		@usernames = Array.new
		@users.each do |user|
			@usernames << user.username
		end
		
		render :json => { :users => @usernames}
	end

	def active_friends
		@users = User.all
		@usernames = Array.new
		@users.each do |user|
			if user.is_active == true
				@usernames << user.username
			end
			
		end
		render :json => { :users => @usernames}
		
	end
	def retrieve_coordinates
		@user = User.where(username: params[:username]).first
		p @user
		render :json => { :lat => @user.lat, :long => @user.long, :user => @user.username  }
	end


	def update
		@user = User.find(params[:user_id])
		@user.lat = params[:latitude]
		@user.long = params[:longitude]
		@user.save!
		p "HEREEE"
		p @user
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
