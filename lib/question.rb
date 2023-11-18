require_relative 'questions_db'

class Question
    attr_accessor :id, :title, :body, :user_id

	def self.find_by_id(id)
		# var stores an array of hash with row as a key and values
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

    # options is a hash of attributes
	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@user_id = options['user_id']
	end
end
