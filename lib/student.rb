class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
     new_student = self.new
     new_student.id = row[0] 
     new_student.name = row[1]
     new_student.grade = row[2]
     new_student
  end

  def self.all
    sql = <<-SQL 
      SELECT * 
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL 
      SELECT * 
      FROM students 
      WHERE name = ? 
      LIMIT 1 
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first 
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

  def self.all_students_in_grade_9 
      sql = <<-SQL 
        SELECT * 
        FROM students 
        WHERE grade = 9
      SQL
      students = []
      students << DB[:conn].execute(sql)
      students
  end 


  def self.students_below_12th_grade 
      sql = <<-SQL 
        SELECT *
        FROM students 
        WHERE grade < 12
      SQL
    students_under_12 = [] 
    DB[:conn].execute(sql).map do |row|
      students_under_12 << self.new_from_db(row)
    end
    students_under_12
  end 

  def self.first_X_students_in_grade_10(limit)
      sql = <<-SQL 
        SELECT * 
        FROM students 
        WHERE grade = 10 
        LIMIT ?
      SQL
      first_X_students_g_10 = []
      DB[:conn].execute(sql, limit).map do |row|
        first_X_students_g_10 << self.new_from_db(row)
      end
      first_X_students_g_10
  end 

  def self.first_student_in_grade_10 
    sql = <<-SQL 
      SELECT * 
      FROM students 
      WHERE grade = 10 
      LIMIT 1 
    SQL

    first_student = nil
    DB[:conn].execute(sql).map do |row| 
      first_student = self.new_from_db(row) 
    end
    return first_student
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL 
      SELECT * 
      FROM students 
      WHERE grade = ? 
    SQL

    students_in_grade_x = []

    DB[:conn].execute(sql, grade).map do |row| 
      students_in_grade_x << self.new_from_db(row)
    end 
    
    students_in_grade_x

  end



end
