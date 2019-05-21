require 'sinatra'
# require 'sinatra/reloader' if development?
require './models/database'

enable :sessions
# configure do
#   set :show_exceptions, false
# end

get '/style.css' do
  scss :style
end

get '/' do
  @title='home'
  erb :home
end

get '/login' do
  @title='login'
  erb :login
end

# check for account username and password while logging in
post '/login/process' do
  if Account.get(params[:name])
    account=Account.get(params[:name])
    if account.password==params[:password]
      session[:name]=params[:name]
      redirect '/'
    else
      session[:info]='wrong_password'
      redirect '/login'
    end
  else
    session[:info]='no_account'
    redirect '/login'
  end
end

# when logout, clear all session
get '/logout' do
  session.clear
  redirect '/'
end

get '/signup' do
  @title='sign up'
  erb :signup
end

# check for account username duplication during signup
post '/signup/process' do
  if Account.get(params[:name])
    session[:info]='duplicate_account'
  else
    account=Account.new
    account.name=params[:name]
    account.password=params[:password]
    account.save
  end
  redirect '/signup'
end

get '/delete_account' do
  account=Account.get(session[:name])
  account.destroy
  session.clear
  redirect '/'
end

get '/student' do
  @title='student'
  @students=Student.all
  erb :student
end

get '/student/add' do
  @title='add a student'
  erb :add_student
end

get '/student/:id' do
  student=Student.get(params[:id])
  @id=params[:id]
  @sid=student.sid
  @firstname=student.firstname
  @lastname=student.lastname
  @birthday=student.birthday
  @address=student.address
  erb :display_student
end

post '/student/form' do
  student=Student.new
  student.sid=params[:sid]
  student.firstname=params[:firstname]
  student.lastname=params[:lastname]
  student.birthday=params[:birthday]
  student.address=params[:address]
  student.save
  redirect '/student'
end

get '/student/delete/:id' do
  student=Student.get(params[:id])
  student.destroy
  redirect '/student'
end

get '/student/edit/:id' do
  student=Student.get(params[:id])
  @id=params[:id]
  @sid=student.sid
  @firstname=student.firstname
  @lastname=student.lastname
  @birthday=student.birthday
  @address=student.address
  erb :edit_student
end

post '/student/form/edit' do
  student=Student.get(params[:id])
  student.update(:sid=>params[:sid])
  student.update(:firstname=>params[:firstname])
  student.update(:lastname=>params[:lastname])
  student.update(:birthday=>params[:birthday])
  student.update(:address=>params[:address])
  redirect '/student'
end

get '/comment' do
  @title='comment'
  @comments=Comment.all
  erb :comment
end

post '/comment/form' do
  comment=Comment.new
  comment.name=params[:name]
  comment.content=params[:content]
  comment.created_at=Time.now
  comment.save
  redirect '/comment'
end

get '/comment/:id' do
  comment=Comment.get(params[:id])
  @name=comment.name
  @content=comment.content
  @created_at=comment.created_at
  erb :display_comment
end

get '/video' do
  @title='video'
  erb :video
end

# error do
#   'server exception'
# end
