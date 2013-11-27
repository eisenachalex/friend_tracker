class User < ActiveRecord::Base
  attr_accessible :lat, :long, :username, :password
  has_secure_password
end
