require_relative 'questions_db'
require_relative 'user'
require_relative 'model_base'

class QuestionFollow < ModelBase
  attr_accessor :id, :question_id, :user_id

  def self.followers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.id, users.fname, users.lname FROM users
      INNER JOIN question_follows
      ON users.id = question_follows.user_id
      WHERE question_follows.question_id = ?
    SQL

    users.map {|options| User.new(options)}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.id, questions.title, questions.body, questions.user_id FROM questions
      INNER JOIN question_follows
      ON questions.id = question_follows.question_id
      WHERE question_follows.user_id = ?
    SQL

    questions.map {|options| Question.new(options)}
  end
    
  # options is a hash of attributes
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end