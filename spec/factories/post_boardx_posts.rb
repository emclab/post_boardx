# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_boardx_post, :class => 'PostBoardx::Post' do
    subject "MyString"
    content "MyText"
    submitted_by_id 1
    last_updated_by_id 1
    category_id 1
    start_date Date.today
  end
end
