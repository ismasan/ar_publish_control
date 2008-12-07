require File.dirname(__FILE__) + '/spec_helper.rb'

describe ArPublishControl do
  it "should have array of available statuses" do
    (ArPublishControl::STATUSES == [:published, :draft, :upcoming, :expired]).should be_true
  end
end

describe Comment do
  before(:each) do
    Post.destroy_all
    @published_post = Post.create do |p|
      p.title         = 'some post'
      p.publish_at    = 1.day.ago
      p.unpublish_at  = 2.days.from_now
    end
    
    @unpublished_post = Post.create do |p|
      p.title         = 'some other post'
      p.publish_at    = 1.day.from_now
      p.unpublish_at  = 2.days.from_now
    end
    
    @published_comment_in_published_post = @published_post.comments.create do |c|
      c.body         = 'some comment'
      c.publish_at    = 2.day.ago
      c.unpublish_at  = 2.days.from_now
    end
    
    @published_comment_in_unpublished_post = @unpublished_post.comments.create do |c|
      c.body         = 'some other comment'
      c.publish_at    = 1.day.ago
      c.unpublish_at  = 2.days.from_now
    end
    
    @unpublished_comment_in_published_post = @published_post.comments.create do |c|
      c.body         = 'some other comment 2'
      c.publish_at    = 1.day.from_now
      c.unpublish_at  = 2.days.from_now
    end
    
    @unupublished_comment_in_unpublished_post = @unpublished_post.comments.create do |c|
      c.body         = 'some other comment 3'
      c.publish_at    = 1.day.from_now
      c.unpublish_at  = 2.days.from_now
    end
    
  end
  
  it "should find published comment at class level" do
    Comment.published.size.should == 2
  end
  
  it "should find published comments in collection" do
    @published_post.comments.published.size.should == 1
  end
  
  it "should find published comments in a collection with conditions" do
    @published_post.published_comments.size.should == 1
  end
  
  it "should work with named scope at class level" do
    Comment.published.size.should == 2
  end
  
  it "should work with named scope at collection level" do
    @published_post.comments.published.size.should == 1
  end
  
  it "should find unpublished with named scope" do
    Comment.unpublished.size.should == 2
    @published_post.comments.unpublished.size.should == 1
  end
  
  it "should chain correctly with other scopes" do
    Comment.published.desc.should == [@published_comment_in_unpublished_post,@published_comment_in_published_post]
  end
  
  it "should chain correctly with other scopes on collections" do
    @unpublished_comment_in_published_post.publish_at = @published_comment_in_published_post.publish_at + 1.hour
    @unpublished_comment_in_published_post.save
    @published_post.comments.reload
    @published_post.comments.published.desc.should == [@unpublished_comment_in_published_post,@published_comment_in_published_post]
  end
  
  it "should find all with conditional flag" do
    Comment.published_only.size.should == 2
    Comment.published_only(true).size.should == 2
    @published_post.comments.published_only(true).first.should == @published_comment_in_published_post
    @published_post.comments.published_only(true).include?(@unpublished_comment_in_published_post).should be_false
    @published_post.comments.published_only(false).include?(@unpublished_comment_in_published_post).should be_true
    @published_post.comments.published_only(false).include?(@published_comment_in_published_post).should be_true
  end
  
  it "should validate that unpublish_at is greater than publish_at" do
    @published_comment_in_published_post.unpublish_at = @published_comment_in_published_post.publish_at - 1.minute
    @published_comment_in_published_post.save
    @published_comment_in_published_post.should_not be_valid
    @published_comment_in_published_post.errors.on(:unpublish_at).should == "should be greater than publication date or empty"
  end
  
end

# describe Post, 'with no dates' do
#   it "should be published" do
#     puts "DESTROYING #{Post.count}============="
#     Post.destroy_all
#     puts "====================================="
#     post = Post.create(:title => 'some post aaaaaaaaaaaaaaaaaaaaaaaaaaaa')
#     post.published?.should be_true
#     Post.published.include?(post).should be_true
#   end
# end

describe Post, "unpublished by default" do
  before(:each) do
    Article.destroy_all
    @a1 = Article.create(:title=>'a1')
    @invalid = Article.create(:title=>'a2', :publish_at => '')
  end
  
  it "should be valid" do
    @a1.should be_valid
    @a1.publish_at.should_not be_nil
    @invalid.publish_at.should_not be_blank
  end
  
  it "should be unpublished by default" do
    @a1.published?.should_not be_true
    Article.published.size.should == 0
  end
  
  it "should publish" do
    @a1.publish!
    @a1.published?.should be_true
  end
end

describe Post, 'upcoming' do
  before(:each) do
    Post.destroy_all
    @p1 = Post.create(:title => 'p1',:is_published => true,:publish_at => 1.day.from_now) #upcoming
    @p2 = Post.create(:title => 'p2',:is_published => true,:publish_at => 1.week.from_now)#upcoming
    @p3 = Post.create(:title => 'p3',:is_published => false,:publish_at => 1.day.from_now)#unpublished
    @p4 = Post.create(:title => 'p4',:is_published => true)#published
  end
  
  it "should have upcoming" do
    @p1.upcoming?.should be_true
    @p2.upcoming?.should be_true
    @p3.upcoming?.should be_false
    @p4.upcoming?.should be_false
    Post.upcoming.size.should == 2
  end
end

describe Post, 'expired' do
  before(:each) do
    Post.destroy_all
    @p1 = Post.create(:title => 'p1',:is_published => true,:publish_at => 2.weeks.ago) #published
    @p2 = Post.create(:title => 'p2',:is_published => true,:publish_at => 2.weeks.ago,:unpublish_at => 1.day.ago)#expired
    @p3 = Post.create(:title => 'p3',:is_published => false,:publish_at => 3.days.ago,:unpublish_at => 2.hours.ago)#unpublished and expired
  end
  
  it "should have expired" do
    @p1.expired?.should be_false
    @p2.expired?.should be_true
    @p3.expired?.should be_true
    Post.expired.size.should == 2
  end
end

describe Post, 'draft' do
  before(:each) do
    Post.destroy_all
    @p1 = Post.create(:title => 'p1',:is_published => true,:publish_at => 2.weeks.ago) #published
    @p2 = Post.create(:title => 'p2',:is_published => true,:publish_at => 2.weeks.ago,:unpublish_at => 1.day.ago)#expired
    @p3 = Post.create(:title => 'p3',:is_published => false,:publish_at => 3.days.ago,:unpublish_at => 2.hours.ago)#unpublished and expired
  end
  
  it "should have draft" do
    Post.draft.count.should == 1
    Post.draft.first.should == @p3
  end
end

describe "new record" do
  it "should default to Time.now" do
    # d = Time.now
    #     Time.stub!(:now).and_return d
    a = Article.new
    a.publish_at.should_not be_nil
  end
end
