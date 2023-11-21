require_relative 'questions_db'
require_relative 'question'
require_relative 'reply'

class User
  attr_accessor :id, :fname, :lname

	def self.find_by_id(id)
		# var stores an array of hash with row as a key and values
		user = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT 
				*
			FROM
				users
			WHERE 
			  id = ?
		SQL

		raise "user with id #{id} is not in database" if user.empty?
		User.new(user.first)
	end

	def self.find_by_name(fname, lname)
		# var stores an array of hash with row as a key and values
		user = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
			SELECT 
				*
			FROM
				users
			WHERE 
			  users.fname = :fname AND users.lname = :lname
		SQL

		raise "user with a name #{fname} #{lname} is not in database" if user.empty?
		User.new(user.first)
	end

  # options is a hash of attributes
	def initialize(options)
		@id = options['id']
		@fname = options['fname']
		@lname = options['lname']
	end

	def save
		is_saved = self.id == nil ? false : true

		unless is_saved
			QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
				INSERT INTO users(fname, lname)
				VALUES (?, ?)
			SQL

    	self.id = QuestionsDatabase.instance.last_insert_row_id
		else
			QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
				UPDATE
				 users
				SET
					fname = ?, lname = ?
				WHERE
				 users.id = ?
			SQL
		end
	end

	def authored_questions
		Question.find_by_author_id(self.id)
	end

  def authored_replies
    Reply.find_by_author_id(self.id)
  end
end