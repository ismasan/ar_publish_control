begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'ar_publish_control'

ActiveRecord::Base.establish_connection(
  :adapter=>'sqlite3',
  :dbfile=> File.join(File.dirname(__FILE__),'db','test.db')
)

#ActiveRecord::Base.connection.query_cache_enabled = false

LOGGER = Logger.new(File.dirname(__FILE__)+'/log/test.log')
ActiveRecord::Base.logger = LOGGER

class Comment < ActiveRecord::Base
  belongs_to :post
  
  named_scope :recent, lambda{|limit|
    {:order => 'created_at desc',:limit => limit}
  }
  
  named_scope :desc, :order => 'publish_at desc'
  
  publish_control
  
end

class Post < ActiveRecord::Base
  
  has_many :comments, :dependent => :destroy
  
  has_many :published_comments, :class_name => 'Comment', :conditions => Comment.published_conditions
  
  publish_control
  
end

class Article < ActiveRecord::Base
  publish_control :publish_by_default => false
end
