require 'spec_helper'

module PostBoardx
  describe Post do
    it "should be OK" do
      c = FactoryGirl.build(:post_boardx_post)
      c.should be_valid
    end
    
    it "should reject nil subject" do
      c = FactoryGirl.build(:post_boardx_post, :subject=> nil)
      c.should_not be_valid
    end
    
    it "should reject nil content" do
      c = FactoryGirl.build(:post_boardx_post, :content => nil)
      c.should_not be_valid
    end
    
    it "should reject nil start date" do
      c = FactoryGirl.build(:post_boardx_post, :start_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil expire date" do
      c = FactoryGirl.build(:post_boardx_post, :expire_date => nil)
      c.should_not be_valid
    end
  end
end
