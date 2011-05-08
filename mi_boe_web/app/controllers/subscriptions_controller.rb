class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  # GET /users/:user_id/subscriptions
  # GET /users/:user_id/subscriptions.xml
  def index
    @subscriptions = Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subscriptions }
    end
  end

  # GET /users/:user_id/subscriptions/:subscription_id
  # GET /users/:user_id/subscriptions/:subscription_id.xml
  def show
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subscription }
    end
  end

  # GET /users/:user_id/subscriptions/new
  # GET /users/:user_id/subscriptions/new.xml
  def new
    @subscription = Subscription.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subscription }
    end
  end

  # GET /users/:user_id/subscriptions/:subscription_id/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /users/:user_id/subscriptions
  # POST /users/:user_id/subscriptions.xml
  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.user = current_user

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to(user_subscription_url(current_user,@subscription), :notice => 'Subscription was successfully created.') }
        format.xml  { render :xml => @subscription, :status => :created, :location => @subscription }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/:user_id/subscriptions/:subscription_id
  # PUT /users/:user_id/subscriptions/:subscription_id.xml
  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to(user_subscription_url(current_user,@subscription), :notice => 'Subscription was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:user_id/subscriptions/:subscription_id
  # DELETE /users/:user_id/subscriptions/:subscription_id.xml
  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to(user_subscriptions_url(current_user)) }
      format.xml  { head :ok }
    end
  end
end
