class WelcomeController < ApplicationController
	def index
		@user = User.new
		@users = User.all

	end

	def test
		p params
		p "t-t-t-twelve twelve carats"
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
			timeLapse = (Time.now.utc - 6.days)
			print "TIME LAPSE "
			p timeLapse
			if (session.receiver == params[:current_user]) && (@sender.is_active == false) && (session.updated_at > 5.minutes.ago)
				p "lapse"
				@user_sessions << session.sender
			end
			
		end
		render :json => { :users => @user_sessions}
		
	end
	def retrieve_coordinates
		@user = User.where(username: params[:username]).first
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
		@user.save!
		p "HEREEE"
		p @user
	end

	def login
		p params
		@user = User.find_by_username(params[:username])

		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			p "success"
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
