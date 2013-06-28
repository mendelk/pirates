require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'slim'

require_relative 'helpers'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/dev.db")

class Pirate
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :slug, String, :key => true
  property :weight, String
  property :height, String
  has n, :ships
  SLUG = 'pirates'
end

class Ship
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :type, String
  property :booty, String
  belongs_to :pirate
end

DataMapper.finalize.auto_upgrade!


module MendelsPirates

  class App < Sinatra::Base

    helpers Helpers

    get '/' do
      slim :'index'
    end

    get '/pirates' do
      @pirates = Pirate.all
      slim :"#{Pirate::SLUG}/index"
    end

    get '/pirates/new' do
      slim :"#{Pirate::SLUG}/new"
    end

    get '/pirates/:slug' do |slug|
      @pirate = Pirate.first(slug:slug)
      slim :"#{Pirate::SLUG}/show"
    end

    post '/pirates' do

      params[:pirate][:slug] = generate_slug params[:pirate][:name]

      # raise params[:pirate].inspect

      pirate = Pirate.first_or_create({:slug => params[:pirate][:slug]}, params[:pirate])
      params[:pirate_ship].each do |ship|
        pirate.ships << ship
      end
      if pirate.save!
        redirect "/#{Pirate::SLUG}/#{pirate.slug}"
      else
        redirect "/#{Pirate::SLUG}/new"
      end
    end

    delete '/pirates/:slug' do |slug|
      pirate = Pirate.first(slug:slug)
      pirate.destroy!
      redirect "/#{Pirate::SLUG}"
    end

  end
end