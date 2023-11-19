require_relative 'questions_db'

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
    
    # options is a hash of attributes
	def initialize(options)
		@id = options['id']
		@question_id = options['question_id']
		@user_id = options['user_id']
	end
end