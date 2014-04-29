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
		@users = User.where(:is_active => false)
		@usernames = Hash.new
		@users.each do |user|
			userHash = {user.username => user.is_active}
			@usernames.merge!(userHash)
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
