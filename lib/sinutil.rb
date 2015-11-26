require 'bundler'
Bundler.require
require 'github_hook'
require 'ostruct'
require 'time'
require 'pry'
require 'yaml'

class UtilBlog < Sinatra::Base
  use GithubHook

  enable :logging
  set :articles, []
  set :app_file, __FILE__

  set :root, File.expand_path('../../', __FILE__)

  Dir.glob "#{root}/articles/*.md" do |file|
    meta, content = File.read(file).split("\n\n", 2)
    article = OpenStruct.new YAML.load(meta)
    article.content = content
    article.slug = File.basename(file, '.*')

    get "/#{article.slug}" do
      erb :post, locals: { article: article }
    end

    articles << article
  end

  articles.sort_by! { |article| article.date }.reverse!

  get '/' do
    erb :index
  end
end
