class ArticlesController < ApplicationController
  include ArticlesHelper
  before_filter :require_login, except: [:index, :show]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])

    # Create a blank comment object that user 
    # can use to create a new comment
    @comment = Comment.new
    @comment.article_id = @article.id
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.create(article_params)
    flash.notice = "Article #{@article.id} Has Been Created!"

    redirect_to article_url(@article)
  end

  def destroy 
    @article = Article.destroy(params[:id]) 
    flash.notice = "Article #{@article.id} Has Been Destroyed!" 

    redirect_to articles_url
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id]) # find the article we are editing
    @article.update(article_params)      # after running the params hash through helper, update
    flash.notice = "Article #{@article.id} Has Been Updated!"

    redirect_to article_url(@article)    # redirect to updated article

  end
end
