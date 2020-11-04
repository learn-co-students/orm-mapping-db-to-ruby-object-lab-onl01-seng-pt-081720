class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new()
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    all_students = DB[:conn].execute(sql)
    all_students.map do |student_from_db|
      self.new_from_db(student_from_db)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT id, name, grade FROM students WHERE name = ?
    SQL
    student_from_db = DB[:conn].execute(sql, name)[0]
    self.new_from_db(student_from_db)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  # grade methods
  def self.all_students_in_grade_9
    grade_to_work_with = 9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    result = DB[:conn].execute(sql, grade_to_work_with)
  end

  def self.students_below_12th_grade
    grade_to_work_with = 12
    sql = <<-SQL
      SELECT * FROM students WHERE grade < ?
    SQL
    result = DB[:conn].execute(sql, grade_to_work_with)[0]
    array_students = []
    array_students << self.new_from_db(result)
  end

  def self.first_X_students_in_grade_10(num_students)
    grade_to_work_with = 10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ? LIMIT ?
    SQL
    result_from_execution = DB[:conn].execute(sql, grade_to_work_with, num_students)

    result_from_execution.map do |student_from_db|
      self.new_from_db(student_from_db)
    end
  end

  def self.first_student_in_grade_10
    grade_to_work_with = 10
    amount_to_limit = 1
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ? LIMIT ?
    SQL
    result_from_execution = DB[:conn].execute(sql, grade_to_work_with, amount_to_limit)[0]
    self.new_from_db(result_from_execution)
  end

  def self.all_students_in_grade_X(grade_selection)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    result_from_execution = DB[:conn].execute(sql, grade_selection)
    result_from_execution.map do |student_from_db|
      self.new_from_db(student_from_db)
    end
  end

end
