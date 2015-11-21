require 'rails_helper'

RSpec.describe User::TimeLogsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user }

  before do
    session[:user_id] = user.id
  end

  describe "GET index" do
    before { get :index }

    it "assigns variables" do
      expect(assigns(:condition)).to be_falsey
      expect(assigns(:time_logs).class).to eq TimeLog::ActiveRecord_Associations_CollectionProxy
    end

    it { expect(response).to render_template("index") }
  end

  describe "GET show" do
    before { get :show, id: time_log }

    it "assigns variables" do
      expect(assigns(:time_log)).to eq time_log
    end

    it { expect(response).to render_template("show") }
  end

  describe "POST create" do
    subject { post :create, time_log: { end_at: Time.now } }

    it "creates time_log" do
      leads.to change{ TimeLog.count }.from(0).to(1)
    end

    it { leads{ response }.to redirect_to time_logs_path }
  end

  describe "PATCH update" do
    let(:param) { params_from_time(Time.now - 10.minute, :end_at) }
    let(:old_time) { time_log.end_at }
    subject do
      patch :update, id: time_log.id, time_log: param
      time_log.reload
    end

    it "updates time_log" do
      leads.to change{ time_log.end_at }.from(old_time).to(Time.zone.local(*param.values))
    end

    it { leads{ response }.to redirect_to time_log_path(time_log) }
  end
end
