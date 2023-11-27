require 'active_support/inflector'

class ModelBase

  # return name of the class as a string in plural
  def self.table
    self.to_s.tableize
  end

  def self.find_by_id(id)
    # var stores an array of hash with row as a key and values
    data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT 
        *
      FROM
        #{table}
      WHERE 
        id = :id
    SQL

    data.nil? ? nil : self.new(data.first)
  end

  def self.all
    # var stores an array of hash with row as a key and values
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT 
        *
      FROM
        #{table}
    SQL

    data.map {|options| self.new(options)}
  end
end