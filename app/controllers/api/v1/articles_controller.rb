class Api::V1::ArticlesController < Api::V1::ApiController
  def index
    begin
      @query = params[:query]
      @from = params[:from].to_time.in_time_zone.beginning_of_day if !params[:from].blank?
      @to = params[:to].to_time.in_time_zone.end_of_day if !params[:to].blank?
      page = params[:page].blank? ? "1" : params[:page]
      @articles = Article.search_by(@query).logs_duration(@from, @to).order(:created_at => :desc).page(page).per(25)
      json_response = { success: true, data: get_atricles(@articles) }
      render json: json_response
    rescue => e
      render json: { success: false, message: e }
    end
  end

  def create
    begin
      @article = Article.new(allowed_params)
      if @article.save!
        render json: { success: true, message: 'Article created successfully.' }
      else
        render json: { success: false, message: 'Article creation failed. Try Again!!!' }
      end
    rescue => e
      render json: { success: false, message: e }
    end
  end

  def show
    begin
      article = Article.find_by_id(params[:id])
      if !article.nil?
        render json: { success: true, data: {
          :id => article.id,
          :title => article.title.blank? ? "" : article.title,
          :body => article.body.blank? ? "" : article.body,
          :created_date => article.created_at.nil? ? "" : article.created_at.strftime("%d/%m/%Y")
        } }
      else
        render json: { success: false, message: "Article Id Could not be found" }
      end
    rescue => e
      render json: { success: false, message: e }
    end
  end

  def update
    begin
      article = Article.find_by_id(params[:id])
      if !article.nil?
        article.update_attributes(allowed_params)
        render json: { success: true, data: {
          :id => article.id,
          :title => article.title.blank? ? "" : article.title,
          :body => article.body.blank? ? "" : article.body,
          :created_date => article.created_at.nil? ? "" : article.created_at.strftime("%d/%m/%Y")
        } }
      else
        render json: { success: false, message: "Article Id Could not be found" }
      end
    rescue => e
      render json: { success: false, message: e }
    end
  end

  def destroy
    begin
      article = Article.find_by_id(params[:id])
      if !article.nil?
        if article.destroy
          render json: { success: true, message: 'Article deleted successfully.' }
        else
          render json: { success: false, message: 'Article deletion failed. Try Again!!!' }
        end
      else
        render json: { success: false, message: "Article Id Could not be found" }
      end
    rescue => e
      render json: { success: false, message: e }
    end
  end

  def allowed_params
    params.permit(:title, :body)
  end

  def get_atricles(articles)
    prs = []
    articles.each do |article|
      data = {
        :id => article.id.blank? ? "" : article.id,
        :title => article.title.blank? ? "" : article.title,
        :body => article.body.blank? ? "" : article.body,
        :created_date => article.created_at.nil? ? "" : article.created_at.strftime("%d/%m/%Y")
      }
      prs << data
    end
    prs
  end
end

