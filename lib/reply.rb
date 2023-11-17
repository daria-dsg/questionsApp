require_relative 'questions_db'

class Reply
    attr_accessor :id, :user_id, :question_id, :body

	def self.find_by_id(id)
		# var stores an array of hash with row as a key and values
		reply = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT 
				*
			FROM
				replies
			WHERE 
			  id = ?
		SQL
        
		Reply.new(reply.first)
	end

    # options is a hash of attributes
	def initialize(options)
		@id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
		@body = options['body']
	end
end
