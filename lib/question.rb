require_relative 'questions_db'

class Question
	def self.find_by_id(id)
		# question stores an array of hash with row as a key and values
		question = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT 
				*
			FROM
				questions
			WHERE 
			  id = ?
		SQL

		Question.new(question.first)
	end

    # init var by accesing hash with key
	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@user_id = options['user_id']
	end
end
