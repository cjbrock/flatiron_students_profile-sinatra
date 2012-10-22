require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'sqlite3'
##### connect to database #####
db =  SQLite3::Database.open('studentinfo.sqlite')
students = []
##### get student pictures #####
css = Nokogiri::HTML(open("http://students.flatironschool.com/css/matz.css"))
images = css.to_s.scan(/\.(.*?-photo)[^}]+?background:.*?\(([\S\s]+?)\)/)
##### get student urls #####
index = Nokogiri::HTML(open("http://students.flatironschool.com/"))
index.css('.one_third a').each {|e| students << e['href']}
##### get individual student information #####
id = 0
students.each do |url|
	next if url == "billymizrahi.html"
	cred = {}
	contact = {}
	tagline = ""
	app_names = []
	app_decs = []
	first_name=""
	last_name=""
	bio=""
	image_url = ""
	studentID = nil

	page = Nokogiri::HTML(open("http://students.flatironschool.com/#{url}"))
	#get image name
	image_name = page.css('#navcontainer div').first['class']
	# cred
	page.css('.one_fifth a').each { |e| cred[e.children.first['class']] = e['href']} 
	#contact
	page.css('#side-nav li').each { |e| contact[e['class']] = e.children.first['href']} 
	# tagline
	tagline = page.css('h2#tagline').first.inner_text 
	# fav apps names
	page.css('.two_third .one_third h4').each { |e| app_names << e.inner_text  } 
	# fav apps desc
	page.css('.two_third .one_third p').each { |e| app_decs << e.inner_text  }
	#name
	page.css('.two_third h1').each do |e| 
		first_name = e.content.split.first
		last_name = e.content.split.last
	end
	#bio
	bio = page.css('.two_third h2~p').inner_text
	##### adding data to database! #####
	images.each do |e|
		if image_name == e[0]
			image_url = e[1]
		end
	end
	feed_1 = ""
	feed_2 = ""
	puts cred.inspect
	data = [first_name,last_name,image_url,bio,tagline,contact["email"],contact["blog"],contact["linkedin"],contact["twitter"],cred["cred-github"],cred["cred-codeschool"],cred["cred-coderwall"],cred["cred-stackoverflow"],cred["cred-treehouse"],feed_1,feed_2]
	db.execute("INSERT INTO students (first_name,last_name,picture,bio,tagline,email,blog,linkedin,twitter,github,codeschool,coderwall,stackoverflow,treehouse,feed_1,feed_2) 
		VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", data)
	 i = 0
	while i < app_names.length
		db.execute("INSERT INTO fav_apps (students_id,name,description)
			VALUES(?, ?, ?)", [id,app_names[i],app_decs[i]])
		i +=1
	end
	id+=1
end

