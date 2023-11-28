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

  def attrs
    Hash[
      instance_variables.map do
        |name| [name.to_s[1..-1], instance_variable_get(name)]
      end
    ]
  end

  def save
    is_saved = self.id == nil ? false : true
    vars = self.instance_variables

    unless is_saved
      QuestionsDatabase.instance.execute(<<-SQL, *vars)
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
end