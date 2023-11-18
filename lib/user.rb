require_relative 'questions_db'

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
end