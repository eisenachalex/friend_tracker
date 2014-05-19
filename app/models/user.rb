
class User < ActiveRecord::Base
  attr_accessible :lat, :long, :username, :mobile, :password
  has_secure_password

end
