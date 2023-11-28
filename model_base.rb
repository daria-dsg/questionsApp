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

  def self.where(params)
    values = params.values
    keys = params.keys.map {|name| name.to_s + "= ?"}.join(" , ")

    data = QuestionsDatabase.instance.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{table}
      WHERE
        #{keys}
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

  def create
    raise 'already saved' unless id.nil?
    
    # get array of instance variables values to pass to heredoc
    instance_attrs = attrs
    instance_attrs.delete("id")
    values = instance_attrs.values

    # get string of instance variables names
    keys = instance_attrs.keys.join(", ")

    # get string of question marks
    question_marks = (["?"] * instance_attrs.count).join(", ")

    QuestionsDatabase.instance.execute(<<-SQL, *values)
      INSERT INTO
        #{self.class.table}(#{keys})
      VALUES
        (#{question_marks})
    SQL

    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise 'not in database' if id.nil?

    # get array of instance variables values to pass to heredoc
    instance_attrs = attrs
    id = instance_attrs.delete("id")
    values = instance_attrs.values

    # get a string with name of attribute and quesion mark
    keys = instance_attrs.keys.map {|name| name.to_s + "= ?"}.join(" , ")

    QuestionsDatabase.instance.execute(<<-SQL, *values, id)
      UPDATE
        #{self.class.table}
      SET
        #{keys}
      WHERE
        #{self.class.table}.id = ?
      SQL
  end
end