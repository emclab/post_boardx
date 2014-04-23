require 'spec_helper'

describe "LinkTests" do
  describe "GET /post_boardx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'post_boardx_posts', :masked_attrs => '-expire_date', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "PostBoardx::Post.where('post_boardx_posts.expire_date >= ? OR post_boardx_posts.expire_date IS NULL', Date.today).where('post_boardx_posts.start_date <= ?', Date.today).order('expire_date, start_date DESC')")     
        
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'post_boardx_posts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'post_boardx_posts', :masked_attrs => '-start_date, -expire_date', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_public_post', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      qs1 = FactoryGirl.create(:post_boardx_post, :last_updated_by_id => @u.id, :expire_date => Date.today + 2.days, :start_date => 10.days.ago)
        
      visit posts_path
      save_and_open_page
      page.should have_content('Posts')
      click_link 'Edit'
      page.should have_content('Edit Post')
      save_and_open_page
      fill_in 'post_subject', :with => 'a test bom'
      click_button 'Save'
      #with wrong data
      visit posts_path
      #save_and_open_page
      page.should have_content('Posts')
      click_link 'Edit'
      fill_in 'post_content', :with => ''
      click_button 'Save'
      save_and_open_page
      
      visit posts_path
      click_link qs1.id.to_s
      save_and_open_page
      page.should have_content('Post Info')
      click_link 'New Log'
      save_and_open_page
      page.should have_content('Log')
      
      visit new_post_path()
      save_and_open_page
      page.should have_content('New Post')
      fill_in 'post_subject', :with => 'a test bom'
      fill_in 'post_content', :with => 'a test spec'
      fill_in 'post_start_date', :with => Date.today
      click_button 'Save'
      #save_and_open_page
      #with wrong data
      visit new_post_path
      fill_in 'post_subject', :with => ''
      fill_in 'post_content', :with => 'a test spec'
      fill_in 'post_start_date', :with => Date.today
      click_button 'Save'
      #save_and_open_page
      
    end
  end
end
