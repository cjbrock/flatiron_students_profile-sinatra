require 'sinatra'
require 'sqlite3'

require_relative 'studentclass'

class Student
	attr_accessor :student_info


  get '/' do
		erb :index
  end

  get '/:id' do
  	@student_info = {}
  	student = Student.new
  	@student_info = student.find(1)
  	erb :student_page
  	
	end
end