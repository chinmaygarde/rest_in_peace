class RestedDB
  autoload :Generator, 'rested_db/generator'  
  
  def create_project
    g = Generator.new("/Users/Buzzy/Desktop/projrested")
    g.generate_project
    g.generate_model("Post id:integer name:string profession:string")
  end
  
end
#DataMapper::Logger.new($stdout, :debug)
#DataMapper.setup(:default, "sqlite3::memory:")
#
#class Post
#	include DataMapper::Resource
#	
#	property :id, Serial
#	property :title, String
#	property :body, Text
#	property :date_tile, DateTime
#	
#end
#
#class Comment
#	include DataMapper::Resource
#	
#	property :id, Serial
#	property :post_id, Integer
#	property :body, Text
#	property :created_at, DateTime
#
#end
#
#DataMapper.auto_migrate!