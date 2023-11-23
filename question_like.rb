require_relative 'questions_db'
require_relative 'user'
require_relative 'question'

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

  def self.num_likes_for_question_id(question_id)
    QuestionsDatabase.instance.get_first_value(<<-SQL, question_id: question_id)
      SELECT
        COUNT(questions_likes.user_id) AS count
      FROM
        questions_likes
      WHERE 
        questions_likes.question_id = :question_id
      GROUP BY
        questions_likes.question_id
    SQL
  end

  def self.liked_questions_for_user_id(user_id)
    questions_data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        questions_likes
      ON
        questions.id = questions_likes.question_id
      WHERE
        questions_likes.user_id = :user_id
    SQL

    questions_data.map {|data| Question.new(data)}
  end

  # options is a hash of attributes
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
