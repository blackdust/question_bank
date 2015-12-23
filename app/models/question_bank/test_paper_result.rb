module QuestionBank
  class TestPaperResult
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user, :class_name => QuestionBank.user_class
    belongs_to :test_paper, :class_name => "QuestionBank::TestPaper"
    has_and_belongs_to_many :question_records, class_name:'QuestionBank::QuestionRecord'
    accepts_nested_attributes_for :question_records, allow_destroy: true


    def to_create_hash
      hash = {}
      self.question_records.each do |qr|
        hash[qr.question_id.to_s] = {
          :is_correct     => qr.is_correct,
          :correct_answer => qr.correct_answer
        }
      end
      hash
    end

    def question_records_attributes=(hash)
      @question_records_user_ids = []
      @question_records_user_ids = hash.map do |key,value|
        value["user_id"]
      end
    end

    before_validation :deal_illegal_operation
    def deal_illegal_operation
      if @question_records_user_ids.uniq.count != 1 || @question_records_user_ids.uniq.first.to_s != self.user.id.to_s
        errors.add(:user_id, "用户字段非法输入")
      end
    end                           
  end
end
