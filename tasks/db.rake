database_config = {
  :adapter=>'sqlite3',
  :dbfile=> File.join(File.dirname(__FILE__),'..','spec','db','test.db')
}

ActiveRecord::Base.establish_connection(database_config)
# define a migration
class TestSchema < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.boolean  :is_published
      t.datetime :publish_at
      t.datetime :unpublish_at
      t.timestamps
    end
    
    create_table :articles do |t|
      t.string :title
      t.boolean  :is_published
      t.datetime :publish_at
      t.datetime :unpublish_at
      t.timestamps
    end
    
    create_table :comments do |t|
      t.text :body
      t.boolean  :is_published
      t.integer :post_id
      t.datetime :publish_at
      t.datetime :unpublish_at
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
    drop_table :comments
    drop_table :articles
  end
end


namespace :db do
  desc "migrate test schema"
  task :create do
    File.unlink(database_config[:dbfile])
    ActiveRecord::Base.connection # this creates the DB
    # run the migration
    TestSchema.migrate(:up)
  end
  
  desc "Destroy test schema"
  task :destroy do
    TestSchema.migrate(:down)
  end
end