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
    
		raise "reply with id #{id} is not in database" if reply.empty?
		Reply.new(reply.first)
	end

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
		@body = options['body']
	end

  def save
		is_saved = self.id == nil ? false : true

		unless is_saved
			QuestionsDatabase.instance.execute(<<-SQL, self.user_id, self.question_id, self.body)
				INSERT INTO replies(user_id, question_id, body)
				VALUES (?, ?, ?)
			SQL

    	self.id = QuestionsDatabase.instance.last_insert_row_id
		else
			QuestionsDatabase.instance.execute(<<-SQL, self.user_id, self.question_id, self.body, self.id)
				UPDATE
				 replies
				SET
					user_id = ?, question_id = ?, body = ?
				WHERE
				 replies.id = ?
			SQL
		end
	end
end
