require 'csv'
require 'erb'

class Person
  attr_reader "name", "phone", "address", "position", "salary", "slack", "github"

  def initialize(name, phone, address, position, salary, slack, github)
    @name = name
    @phone = phone
    @address = address
    @position = position
    @salary = salary
    @slack = slack
    @github = github
  end
end

class Database
  attr_reader "people"

  def initialize
    @people = []
    CSV.foreach("employees.csv", headers: true) do |row|
      name = row["name"]
      phone = row["phone"]
      address = row["address"]
      position = row["position"]
      salary = row["salary"].to_i
      slack = row["slack"]
      github = row["github"]

      person = Person.new(name, phone, address, position, salary, slack, github)

      @people << person
    end
  end

  def add_people

    # CSV.open("@people.csv", "w") do |csv|
    #   csv << [ "name", "phone", "address", "position", "salary", "slack", "github" ]
    #   people.each do |ppl|
    #     csv << [ppl[:name], ppl[:phone_number], ppl[:address], ppl[:position], ppl[:slack_account], ppl[:github_account]]
    #   end
    # end

    puts "Please provide the name of the person you are adding"
    name = gets.chomp

    if @people.find{ |person| person.name == name}
      puts "That person is already in the system"

    else
      puts "Please provide the phone number of the person you are adding "

      phone = gets.chomp

      puts " Please provide the address of the person you are trying to add"

      address = gets.chomp

      puts "Please provide the position of the person you are adding"

      position = gets.chomp

      puts "Please provide the salary of the person you are adding"

      salary = gets.chomp.to_i

      puts "Please provide the slack account of the person you are adding"

      slack = gets.chomp

      puts "Please provide the GitHub account for the person you are adding"

      github = gets.chomp

      person = Person.new(name, phone, address, position, salary, slack, github)

      @people << person
    end
  end

  def search_people

    puts "What name do you want to search for?"
    search_name = gets.chomp

    # found_person = people.find { |person| person.name == search_name }
    found_person = people.find { |person| person.name == search_name || person.slack == search_name || person.github == search_name || person.name.include?(search_name) }

    if found_person
      puts "Name #{found_person.name}"
      puts "Phone_number #{found_person.phone}"
      puts "Address #{found_person.address}"
      puts "Position #{found_person.position}"
      puts "Salary #{found_person.salary}"
      puts "Slack #{found_person.slack}"
      puts "github #{found_person.github}"
    else
      puts " Sorry but that name is not in our database."
    end
  end

  def delete_people

    puts "Please enter the name you would like to delete"
    delete_name = gets.chomp

    delete_person = people.delete_if {|person| person.name == delete_name}
    if delete_person
      puts " Thank you, #{delete_name} has been deleted from the data base"
    else
      puts "Sorry that name does not exist in our system."
    end
  end

  def save_people
    CSV.open("employees.csv", "w") do |csv|
      csv << [ "name", "phone", "address", "position", "salary", "slack", "github" ]
      @people.each do |person|
        csv << [person.name, person.phone, person.address, person.position, person.slack, person.github]
      end
    end
  end

  def reports_people
    template_string = File.read("report.html.erb")
    erb_template = ERB.new(template_string)
    html = erb_template.result(binding)

    File.write("report.html", html)
  end

  def total_salaries_instructor
    instructors = people.select { |person| person.position == "instructor" }
    salaries = instructors.map { |person|  person.salary }
    total_salary = salaries.sum
    return total_salary
  end

  def total_salaries_campus_directors
    campus_directors = people.select { |person| person.position == "Campus Director"}
    salaries = campus_directors.map { |person| person.salary}
    total_salary = salaries.sum
    return total_salary
  end

  def number_of_instructors
    number_of_instructors = people.count { |person| person.position == "instructor"}
  end

  def number_of_campus_directors
    number_of_campus_directors= people.count { |person| person.position == "Campus Director"}
  end

  def number_of_students
    number_of_students = people.count { |person| person.position == "student"}
  end
end

database = Database.new

loop do
  puts "add a person"
  puts "search a person"
  puts "delete a person"
  puts "Report of database"

  choice = gets.chomp

  if choice == "a"
    database.add_people
    database.save_people
  end

  if choice == "s"
    database.search_people
  end

  if choice == "d"
    database.delete_people
    database.save_people
  end

  if choice == "r"
    database.reports_people
  end
end
