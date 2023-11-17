require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
	include Singleton

  def initialize
  	super('questions.db')
    self.type_translation = true
    self.results_as_hash = true 
  end
end



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

	def initialize(options)
		@id = options['id']
		@title = options['fname']
		@body = options['lname']
		@user = 
	end
end

