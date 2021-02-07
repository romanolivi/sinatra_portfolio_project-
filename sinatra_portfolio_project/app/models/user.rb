require_relative './concerns/slugify.rb'

class User < ActiveRecord::Base 
    has_secure_password 
    has_many :parks 

    validates :username, presence: true 
    validates :password, presence: true 
    validates_uniqueness_of :username 

    include Slugifiable::InstanceMethod
    extend Slugifiable::ClassMethod
end

