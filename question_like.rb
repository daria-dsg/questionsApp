require_relative 'questions_db'
require_relative 'user'
require_relative 'question'
require_relative 'model_base'

class QuestionLike < ModelBase
  attr_accessor :id, :question_id, :user_id

  def self.likers_for_question_id(question_id)
    users_data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes
      ON
        users.id = question_likes.user_id
      WHERE
        question_likes.question_id = :question_id
    SQL

    users_data.map {|data| User.new(data)}
  end

  def self.num_likes_for_question_id(question_id)
    QuestionsDatabase.instance.get_first_value(<<-SQL, question_id: question_id)
      SELECT
        COUNT(question_likes.user_id) AS count
      FROM
        question_likes
      WHERE 
        question_likes.question_id = :question_id
      GROUP BY
        question_likes.question_id
    SQL
  end

  def self.liked_questions_for_user_id(user_id)
    questions_data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = :user_id
    SQL

    questions_data.map {|data| Question.new(data)}
  end

  def self.most_liked_questions(count)
    questions_data = QuestionsDatabase.instance.execute(<<-SQL, count: count)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      GROUP BY
        question_likes.question_id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        :count
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
