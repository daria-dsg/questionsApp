require_relative 'questions_db'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follow'
require_relative 'question'
require_relative 'question_like'
require_relative 'model_base'

class Question < ModelBase
  attr_accessor :id, :title, :body, :user_id

  def self.find_by_author_id(author_id)
    # var stores an array of hash with row as a key and values
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
        SELECT 
          *
        FROM
          questions
        WHERE 
          user_id = ?
      SQL
      
     questions.map {|options| Question.new(options)}
  end

  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL

    questions.map {|options| Question.new(options)}
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  # options is a hash of attributes
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(self.user_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollow.followers_for_question_id(self.id)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id) 
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end
end
