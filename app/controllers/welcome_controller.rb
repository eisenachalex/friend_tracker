class WelcomeController < ApplicationController
	def index
		@user = User.new
		@users = User.all

	end

	def create_session
		@existing_session = Session.where(sender:params[:sender], receiver: params[:receiver]).first
		if @existing_session
			p "OLD NEWS"
			@existing_session.updated_at = DateTime.now
		else
		@session = Session.create(sender: params[:sender], receiver: params[:receiver])
		@session.save!
		end
	end

	def delete_session
		if params[:receiver]
		@session = Session.where(sender: params[:sender], receiver: params[:receiver])
		@session.destroy_all
		else
		@session = Session.where(sender: params[:sender])
		p @session
		@session.destroy_all
		end
	end
	def create
		p params
		@user = User.create(params[:user])
		session[:user_id] = @user.id
	end

	def create_new_user
		p params
		@user = User.where(username: params[:username]).first
		if @user
			render :json => {login_status: "user already exists"}
		end
		@user = User.where(mobile: params[:mobile]).first
		if @user
			render :json => {login_status: "mobile number already exists"}
		end
		@user = User.create(username: params[:username], mobile: params[:mobile], password: params[:password])
		if @user
			@user.save!
			render :json => {login_status: "new user created"}
		end
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
		@sessions= Session.all
		@user_sessions = Array.new
		@sessions.each do |session|
			p "uPDATED AT" 
			p session.updated_at
			@sender = User.where(username: session.sender).first
			last_updated = @sender.updated_at
			if (session.receiver == params[:current_user]) && (@sender.is_active == true) && ((Time.now - last_updated) < 30)
				p "lapse"
				@user_sessions << session.sender
			end
			
		end
		render :json => { :users => @user_sessions}
		
	end
	def retrieve_coordinates
		@user = User.where(username: params[:username]).first
		last_updated = @user.updated_at
		if (Time.now - last_updated) > 30)
		p "TIME OUT"
		render :json => { :lat => @user.lat, :long => @user.long, :user => @user.username, :sessionLive => "not_connected" }
		end

		@session = Session.where(sender: params[:username], receiver: params[:current_user]).first
		if @session
		render :json => { :lat => @user.lat, :long => @user.long, :user => @user.username, :sessionLive => "live" }
		else
		render :json => { :lat => @user.lat, :long => @user.long, :user => @user.username, :sessionLive => "not_live"}		
		end
	end


	def update
		@user = User.where(username: params[:username]).first
		@user.lat = params[:latitude]
		@user.long = params[:longitude]
		@user.update_attribute(:updated_at, Time.now);
		@user.save!
		p "HEREEE"
		p @user
	end

	def login
		p params
		@user = User.find_by_username(params[:username])
		p @user.username
		if @user && @user.authenticate(params[:password])
			p "success"
			session[:user_id] = @user.id
			render :json => { :login_status => "success" , :phone_number => @user.mobile}
			p "json should be there"
		else
			p "failure"
			render :json => { :login_status => "failed"}
			p "json shoudl be there"
		end

	end

	def map
		p session[:user_id]
			gon.users = User.all
		gon.current_user = session[:user_id]
	end
end
