#TEST METHODS

# def assert_equal(actual, expected)
#   if expected == actual
#     puts 'pass'
#   else
#     puts "fail: expected #{expected}, got #{actual}"
#   end
# end

# def assert(statement)
#   if statement
#     puts 'pass'
#   else
#     puts "fail: expected #{statement} to be true."
#   end
# end

class Student
  attr_reader :db

  def initialize
    @db = SQLite3::Database.open('studentinfo.sqlite')
  end

  

def find(student_id)
  @db.results_as_hash = true
  student_hash =@db.execute("SELECT * FROM students WHERE id = ?", student_id)[0]
  id = student_hash['id']
  @db.results_as_hash = false
  favs =@db.execute("SELECT * FROM fav_apps WHERE students_id = ?", id)
  student_hash["fav_apps"] = favs
  student_hash
end

end

#  #TEST
# begin
#   assert Student.new.is_a?(Student)
# rescue => e
#   puts e
# end

# student = Student.new

# [:id, :first_name, :last_name, :picture, :bio, :tagline, :email, :blog,
#   :linkedin, :twitter, :github, :codeschool, :coderwall, :stackoverflow,
#   :treehouse, :feed_1, :feed_2].each do |attribute|
#   student.send("#{attribute}=", "value")
#   assert_equal student.send(attribute), "value"
# end

# Student.find(1) #=> #<Student>
# assert Student.find(1).is_a?(Student) 



