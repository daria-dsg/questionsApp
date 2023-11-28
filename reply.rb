require_relative 'questions_db'
require_relative 'user'
require_relative 'model_base'

class Reply < ModelBase
  attr_accessor :id, :user_id, :question_id, :parent_id, :body

  def self.find_by_author_id(author_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT 
        *
      FROM
        replies
      WHERE 
        user_id = ?
    SQL
    
    raise "user with id #{author_id} is not in database" if replies.empty?
    replies.map {|options| Reply.new(options)}
  end

  def self.find_by_question_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM
        replies
      WHERE 
        question_id = ?
    SQL
    
    raise "there are not replies on this question" if replies.empty?
    replies.map {|options| Reply.new(options)}
  end

  # options is a hash of attributes
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    reply = QuestionsDatabase.instance.execute(<<-SQL, self.parent_id)
      SELECT 
        *
      FROM
        replies
      WHERE 
        id = ?
      SQL

    raise "reply with id #{id} does not have parent reply" if reply.empty?
    Reply.new(reply.first)
  end

  def child_replies
    reply = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT 
        *
      FROM
        replies
      WHERE 
        replies.parent_id = ? 
      SQL

    raise "reply with id #{id} does not have child replies" if reply.empty?
    Reply.new(reply.first)
  end
end
