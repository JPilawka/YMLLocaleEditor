
#require 'gitHub'
class LocalesController < ApplicationController

  def index

    if(flash[:alert]!=nil)
      @alert = alert
    else
      @alert =''
    end
    config = "#{Rails.root}/config/locales/"
    files = Dir["#{config}*.yml"]
    @files = files.map{|n| n.split("/").last}
  end

  def show
    #tutaj wyświetlamy wszystkie info z otrzymanego pliku.
    @file = params[:locale_file]
    @search_phrase=""

    @db = Locale.new
    if(params[:search_phrase]!=nil) #Returning results of search form
      @search_phrase=params[:search_phrase]
      @file_lines = @db.searchResults(params[:search_phrase], params[:page])
    else
      @db.conDB
      f=Psych.load_file("config/locales/#{@file}") #opening file to read
      g=f.first
      gg = g.first
      g=g[1]
      parent_key = gg
      @db.insertLocale(gg,'','','')
      parent = @db.selectLastId
      g.each do |key, value|
        isHash(key, value, parent, parent_key)
      end
      @file_lines = @db.ShowAll(params[:page])
    end

  end

  def isHash(key, value, parent, parent_key)
    if(value.class==Hash)
      @db.insertLocale(key, nil, parent, parent_key)
      parent_key = key
      parent = @db.selectLastId
      value.each do |key1, value1|
        isHash(key1, value1, parent, parent_key)
      end

    else
      if(value.class==String)
        @db.insertLocale(key, value.strip.gsub(/\s+/, " "), parent, parent_key)
      else
        @db.insertLocale(key, value, parent, parent_key)
      end
    end

  end

  def create
    #Creating backup file from original (zmienić nazwę na nazwa-data.backupyml)
    file = Locale.new
    file = file.fileName
    #renaming file to prepare backup.
    File.rename("#{Rails.root}/config/locales/" + file+'.yml', "#{Rails.root}/config/locales/" + file+'-'+Time.now.to_s+'.backupyml')
    #Saving to database
    @h = Hash.new{|hsh,key| hsh[key] = []}

    params[:lines].each do |param|

      @h[param[:id]] = {'key' => param[:key]}
      @h[param[:id]].merge!({ 'value'=> param[:value]})

      Locale.update(param[:id], value: param[:value])
    end
    #saving to YML file from database.

    overallHash = findChildTemp(1)
    overallHash = {file=>overallHash}
    #puts @overallHash
    #Writing to file
    File.open("#{Rails.root}/config/locales/" + file+'.yml', 'w') do |file|
      file.write(Psych.dump(overallHash))
    end
    @file = file+'.yml'

  end

  def findChildTemp(id)
    db=Locale.new
    key = Locale.find(id)['key']

    children = findChildren(id)

    allChildrenHash = Hash.new{|hsh,key| hsh[key] = []}
    grandchildrenHash = Hash.new{|hsh,key| hsh[key] = []}
    children.each do |child|
      #<--------
      if(child['value']!=nil)
        grandchildrenHash.merge!(child['key']=>child['value'])
      else
        grandchildren = findChildTemp(child['id'])
        grandchildrenHash.merge!(child['key']=>grandchildren)
      end

      allChildrenHash.merge!(grandchildrenHash)

    end
    allChildrenHash

  end


  def findChildren(id)
    db=Locale.new
    children = db.searchForChildren(id)
    children
  end


  def commit
    config = YAML.load_file("#{Rails.root}/config/config.yml")
    client_id = ENV['gh_client_id']
    client_secret = ENV['gh_client_secret']
    token = ENV['gh_token']
    user = ENV['gh_user']
    password = ENV['gh_password']
    repo = 'YMLLocaleEditor'
    message = params[:message_for_gh].to_s
    github = Github.new client_id: client_id, client_secret: client_secret
    filepath = 'config/locales/'+params[:file]
    filecontent = File.read(filepath)

    github.authorize_url scope: 'repo, user'
    config = Github::Client::Repos::Contents.new :user=> user, :password=>password, oauth_token: token

    file = config.find user: user, repo: repo, path: filepath

    config.update user, repo, filepath, path: filepath, message: message, content: filecontent, sha: file.sha
    flash[:alert] = "File: "+params[:file]+" succesfully committed"
    redirect_to action: "index"
  end


end
