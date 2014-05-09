require_dependency "post_boardx/application_controller"

module PostBoardx
  class PostsController < ApplicationController
    before_filter :require_employee
    
    def index
      @title = t('Posts')
      @posts = params[:post_boardx_posts][:model_ar_r]
      @posts = @posts.where(category_id: params[:catetory_id]) if params[:category_id].present?
      @posts = @posts.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('post_index_view', 'post_boardx')
    end
  
    def new
      @title = t('New Post')
      @post = PostBoardx::Post.new()
      @erb_code = find_config_const('post_new_view', 'post_boardx')
    end
  
    def create
      @post = PostBoardx::Post.new(params[:post], :as => :role_new)
      @post.last_updated_by_id = session[:user_id]
      @post.submitted_by_id = session[:user_id]
      if @post.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('post_new_view', 'post_boardx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Edit Post')
      @post = PostBoardx::Post.find_by_id(params[:id])
      @erb_code = find_config_const('post_edit_view', 'post_boardx')
    end
  
    def update
      @post = PostBoardx::Post.find_by_id(params[:id])
      @post.last_updated_by_id = session[:user_id]
      if @post.update_attributes(params[:post], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('post_edit_view', 'post_boardx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Post Info')
      @post = PostBoardx::Post.find_by_id(params[:id])
      @erb_code = find_config_const('post_show_view', 'post_boardx')
    end
  end
end
