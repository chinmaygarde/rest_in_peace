require 'rubygems'
require 'dm-core'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "mysql://localhost/blog")

class Post
	include Datamapper::Resource
	
	property :id, Serial
	property :title, String
	property :body, Text
	property :date_tile, DateTime
	
end

class Comments
	include Datamapper::Resource
	
	property :id, Serial
	property :post_id, Serial
	property :body, Text
	property :created_at, DateTime

end

Datamapper.auto_migrate!

p = Post.new
p.title = "FooBar"
p.body = "Hello World"
p.save