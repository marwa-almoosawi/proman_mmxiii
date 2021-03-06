def create_supervisor
  @supervsr ||= FactoryGirl.create(:supervisor)
end

def create_student
  @student ||= FactoryGirl.create(:student)
end

def create_project
  @project1 ||= FactoryGirl.create(:project, title: 'First demo project', supervisor: create_supervisor)
end

def create_two_projects
  create_project
  @project2 ||= FactoryGirl.create(:project, title: 'Second demo project', supervisor: create_supervisor, available: false)
end

When /^I visit the projects page$/ do
  create_two_projects
  visit '/projects'
end

Then /^I should see "(.*?)" in the page content$/ do |title|
  page.should have_content title
end

Then /^I should see a list of available projects$/ do
  selector = 'a[href="' + project_path(@project1) + '"]'
  page.should have_selector selector, text: @project1.code
  page.should have_selector selector, text: @project1.title
  page.should have_content 'Available'
end

Then /^I should see all project codes as ids$/ do
  page.should have_selector "#" + @project1.code
  page.should have_selector "#" + @project2.code
end 

Then /^I should also see projects that are not available$/ do
  selector = 'a[href="' + project_path(@project2) + '"]'
  page.should have_selector selector, text: @project2.code
  page.should have_selector selector, text: @project2.title
  page.should have_content 'Not available'
end

When /^I follow a link to a project$/ do
  click_link @project1.code
end

Then /^I should see project code and decription in the header$/ do
  page.should have_selector "article##{@project1.code}"
  page.should have_selector "header h1", text: /^#{@project1.code}.*#{@project1.title}$/
end

Then /^I should see the supervisors details$/ do
  page.should have_content @project1.supervisor_name
  page.should have_content @project1.supervisor_email
  page.should have_content @project1.research_centre_code
  page.should have_content @project1.research_centre_name
end

Then /^I should see the other public project details$/ do
  page.should have_content @project1.status

end

Then /^I should see the project description$/ do
  page.should have_selector "section.project_desciption"
  page.should have_content @project1.description
end

Then /^I should see a link back to projects page for this project$/ do
  selector = 'a[href="' + projects_url + "##{@project1.code}" + '"]'
  page.should have_selector selector
end

Then /^I should see the intended discipline$/ do
  page.should have_content @project1.discipline.name
end

Then /^I should not see any privileged project details$/ do
  page.should_not have_content @project1.available?
end

Given /^there is a student-defined project$/ do
  create_project
  create_student
  @project1.students_own_project = true
  @project1.student_number = @student.student_number
  @project1.student_name = @student.full_name
  @project1.save!
end

Then /^I should see that the project has been defined by a student$/ do
  page.should have_content 'his project has been defined by student with id'
end

Then /^I should see the student's number$/ do
  page.should have_content @student.student_number
end

Then /^I should not see the student's name$/ do
  page.should_not have_content @student.full_name
end

Then /^I should not see the student's email address$/ do
  page.should_not have_content @student.email
end

When /^I visit a projects by discipline page$/ do
  create_project
  visit "/projects/by_discipline/#{@project1.discipline.code}"
end

Then /^I should see the discipline name in the page title$/ do
  page.should have_content "Projects for #{@project1.discipline.name}"
end


Then /^I should see a link back to discipline index for this project$/ do
  selector = 'a[href$="' + "#{@project1.discipline.code}##{@project1.code}" + '"]'
  page.should have_selector selector
end