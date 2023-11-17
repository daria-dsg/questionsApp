class User
	def self.find_by_id(id)
		# user stores an array of hash with row as a key and values
		user = QuestionsDatabase.instance.execute(<<-SQL, id)
			SELECT 
				*
			FROM
				users
			WHERE 
			  id = ?
		SQL

		User.new(user.first)
	end

	def initialize(options)
		@id = options['id']
		@fname = options['fname']
		@lname = options['lname']
	end
end