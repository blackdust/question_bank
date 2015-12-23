require 'rails_helper'

RSpec.describe QuestionBank::TestPaperResult, type: :model do
  describe "题目user_id 合法及不合法" do
    before :example do
      @test_paper = create(:test_paper)
      @user1 = create :user
      @user2 = create :user
      @s1 = create :section
      @q1 = create :question
      @q2 = create :question
      @s1.question_ids << @q1.id
      @s1.question_ids << @q2.id
      @test_paper.sections << @s1
      @current_user = User.first
    end

    describe "题目user_id 不符合current_user" do
      it{
        wrong_create_params_form_page = 
        {
          "0"=>{"question_id"=>"#{@q1.id.to_s}", "user_id"=>"#{@current_user.id.to_s}", "answer"=>"0"}, 
          "1"=>{"question_id"=>"#{@q2.id.to_s}", "user_id"=>"#{User.last.id.to_s}", "answer"=>"1"}
        }
        test_paper_result = @test_paper.test_paper_results.new(:question_records_attributes => wrong_create_params_form_page)
        test_paper_result.user = @current_user
        test_paper_result.save
        expect(test_paper_result.valid?).to eq(false)
        expect(test_paper_result.errors.messages[:user_id].first).to eq("用户字段非法输入")
      }
    end

    describe "题目user_id 不符合current_user" do
      it{
        before_create_count = QuestionBank::TestPaperResult.count
        correct_create_params_form_page = 
        {
          "0"=>{"question_id"=>"#{@q1.id.to_s}", "user_id"=>"#{@current_user.id.to_s}", "answer"=>"0"}, 
          "1"=>{"question_id"=>"#{@q2.id.to_s}", "user_id"=>"#{@current_user.id.to_s}", "answer"=>"1"}
        }
        test_paper_result = @test_paper.test_paper_results.new(:question_records_attributes => correct_create_params_form_page)
        test_paper_result.user = @current_user
        test_paper_result.save
        after_create_count = QuestionBank::TestPaperResult.count
        expect(test_paper_result.valid?).to eq(true)
        expect(after_create_count).to eq(before_create_count+1)
      }
    end
  end
end