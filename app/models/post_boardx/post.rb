module PostBoardx
  class Post < ActiveRecord::Base
    attr_accessor :submitted_by_name, :category_name, :last_updated_by_name
    attr_accessible :category_id, :content, :last_updated_by_id, :subject, :submitted_by_id, :expire_date, :start_date,
                    :as => :role_new                  
    attr_accessible :category_id, :content, :subject, :submitted_by_name, :expire_date, :start_date, :last_updated_by_name,
                    :as => :role_update   
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :submitted_by, :class_name => 'Authentify::User'
    belongs_to :category, :class_name => 'Commonx::MiscDefinition'   
    
    validates :subject, :content, :start_date, :presence => true    
  end
end
