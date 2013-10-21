require 'rubygems'
require 'sinatra'
require 'haml'

require "bundler/setup"

require 'sinatra/activerecord'
configure(:development){ set :database, "sqlite3:///fake_twitter.sqlite3" }

require './models'

require 'sinatra/base'
require 'rack-flash'


enable :sessions
use Rack::Flash, :sweep => true

set :sessions => true

helpers do
  def current_user
    session[:user_id].nil? ? nil : User.find(session[:user_id])
  end
end

def current_user
  session[:user_id].nil? ? nil : User.find(session[:user_id])
end

get '/' do
  @users = User.all
	haml :home
end

get '/sign_in' do
  haml :sign_in
end

post '/sign_in' do
  @user = User.where(:username => params[:username]).first
  if @user
    if @user.password == params[:password]
      session[:user_id] = @user.id
      flash[:notice] = "Welcome back!"
      redirect '/users/' + @user.id.to_s
    else
      flash[:notice] = "Your password was wrong."
      redirect '/'
    end
  else
    flash[:notice] = "You're not a user yet. Sign up below."
    redirect '/users/sign_up'
  end
end

get '/logout' do
  session[:user_id] = nil
  flash[:notice] = "You have been successfully logged out."
  redirect "/"
end

get '/users/sign_up' do
  haml :sign_up
end

get '/follow/:id' do
  @relationship = Relationship.new(follower_id: current_user.id, followed_id: params[:id])
  if @relationship.save
    flash[:notice] = "You've successfully followed #{User.find(params[:id]).fname}."
  else
    flash[:alert] = "There was an error following that user."
  end
  redirect back
end

post '/users/sign_up' do
  User.create(params)
  @users = User.all
  flash[:notice] = "Thanks for signing up!"
  redirect '/'
end

post '/users/:id/tweets/new' do
  @tweet = Tweet.create(:text => params[:tweet])
  @user = User.find(params[:id])
  @user.tweets << @tweet
  redirect '/users/' + @user.id.to_s
end

get '/users/:id' do
  @user = User.find(params[:id])
  haml :profile
end

