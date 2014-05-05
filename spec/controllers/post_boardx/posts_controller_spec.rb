require 'spec_helper'

module PostBoardx
  describe PostsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])

      
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all posts for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "PostBoardx::Post.where('post_boardx_posts.expire_date >= ? OR post_boardx_posts.expire_date IS NULL', Date.today).where('post_boardx_posts.start_date <= ?', Date.today).order('expire_date, start_date DESC')")     
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:post_boardx_post, :last_updated_by_id => @u.id, :expire_date => 2.days.ago, :start_date => 5.days.ago)
        qs1 = FactoryGirl.create(:post_boardx_post, :last_updated_by_id => @u.id, :expire_date => Date.today + 2.days, :start_date => 10.days.ago)
        get 'index' , {:use_route => :post_boardx}
        assigns(:posts).should =~ [qs1]       
      end
      
      it "should not return not started posts" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "PostBoardx::Post.where('post_boardx_posts.expire_date >= ? OR post_boardx_posts.expire_date IS NULL', Date.today).where('post_boardx_posts.start_date <= ?', Date.today).order('expire_date, start_date DESC')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:post_boardx_post, :last_updated_by_id => @u.id, :start_date => Date.today - 5.days)
        qs1 = FactoryGirl.create(:post_boardx_post, :last_updated_by_id => @u.id, :start_date => Date.today + 10.days )
        get 'index' , {:use_route => :post_boardx}
        assigns(:posts).should eq([qs])
      end
      
      it "should pick up posts with nil expire date" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "PostBoardx::Post.where('post_boardx_posts.expire_date >= ? OR post_boardx_posts.expire_date IS NULL', Date.today).where('post_boardx_posts.start_date <= ?', Date.today).order('expire_date, start_date DESC')")     
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:post_boardx_post, :last_updated_by_id => @u.id, :expire_date =>Date.today + 50.days, :start_date => 5.days.ago)
        qs1 = FactoryGirl.create(:post_boardx_post, :last_updated_by_id => @u.id, :expire_date => Date.today + 2.days, :start_date => 10.days.ago)
        get 'index' , {:use_route => :post_boardx}
        assigns(:posts).should =~ [qs, qs1]     
      end
      
    end
  
    describe "GET 'new'" do
      
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :post_boardx}
        response.should be_success
      end
           
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:post_boardx_post)
        get 'create' , {:use_route => :post_boardx,  :post => qs}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:post_boardx_post, :subject => nil)
        get 'create' , {:use_route => :post_boardx,  :post => qs}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:post_boardx_post)
        get 'edit' , {:use_route => :post_boardx,  :id => qs.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:post_boardx_post)
        get 'update' , {:use_route => :post_boardx,  :id => qs.id, :post => {:content => 'newnew'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:post_boardx_post)
        get 'update' , {:use_route => :post_boardx,  :id => qs.id, :post => {:start_date => nil}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:post_boardx_post)
        get 'show' , {:use_route => :post_boardx,  :id => qs.id}
        response.should be_success
      end
    end
    
  end
end
