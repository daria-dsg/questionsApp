require_relative 'questions_db'
require_relative 'user'

class QuestionFollow
  attr_accessor :id, :question_id, :user_id
    
	def self.find_by_id(id)
		# var stores an array of hash with row as a key and values
		follow = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT 
				*
			FROM
				questions_follows
			WHERE 
			  id = ?
		SQL

		QuestionFollow.new(follow.first)
	end

  def self.followers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.id, users.fname, users.lname FROM users
      INNER JOIN questions_follows
      ON users.id = questions_follows.user_id
      WHERE questions_follows.question_id = ?
    SQL

    users.map {|options| User.new(options)}
  end
    
  # options is a hash of attributes
	def initialize(options)
		@id = options['id']
		@question_id = options['question_id']
		@user_id = options['user_id']
	end
end