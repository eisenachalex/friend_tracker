class Session < ActiveRecord::Base
  attr_accessible :sender, :receiver
end
