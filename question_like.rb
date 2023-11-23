require_relative 'questions_db'
require_relative 'user'

class QuestionLike
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    # var stores an array of hash with row as a key and values
    question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM
        questions_likes
      WHERE 
        id = ?
    SQL
        
    QuestionLike.new(question_like.first)
  end

  def self.likers_for_question_id(question_id)
    users_data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        questions_likes
      ON
        users.id = questions_likes.user_id
      WHERE
        questions_likes.question_id = :question_id
    SQL

    users_data.map {|data| User.new(data)}
  end

  # options is a hash of attributes
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
