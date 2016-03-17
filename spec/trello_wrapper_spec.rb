require 'rspec'
require_relative '../src/trello_util.rb'

BOARD_ID     = ENV['TRELLO_BOARD_ID']
API_KEY      = ENV['TRELLO_API_KEY']
MEMBER_TOKEN = ENV['TRELLO_MEMBER_TOKEN']
USER         = ENV['TRELLO_USER']

  describe 'Board' do
    let(:trelloUtil) { TrelloUtil.new(BOARD_ID, API_KEY, MEMBER_TOKEN)}
    let(:user) {Trello::Member.find(USER)}

    it "can list cards" do
      cards =  trelloUtil.listCards
      expect(cards.size).to be > 0
    end

    it "show a card name" do
      card = trelloUtil.listCards[0]
      puts card.name
      expect(card.name).to_not be_nil
    end

    it "can create a card" do
      before = trelloUtil.listCards.size
      card = trelloUtil.addCard("test this")
      expect(trelloUtil.listCards.size).to be > before
      card.delete
    end

    it "shows all board lists" do
      lists = trelloUtil.getLists
      lists.each {|l| puts "list name #{l.name}"}
      expect(lists.size).to be > 0
    end

    it "adds a member to card" do
      card = trelloUtil.addCard("Test adding a member")
      trelloUtil.add_member(card.id, user)
      expect(card.members).to include(user.id)
      card.delete
    end

    it "removes a member" do
      card = trelloUtil.addCard("Test removing a member")
      trelloUtil.add_member(card.id, user)
      trelloUtil.remove_member(card.id, user)
      expect(card.members).not_to include(user.id)
      card.delete
    end

    it "fetches cards by last 2 weeks of activity" do
      cards = trelloUtil.fetchCards(lambda {|card| card.last_activity_date > Date.today - 14 })
      card = trelloUtil.addCard("test for last activity card")
      cards.each {|c| puts "filtered card #{c.name} with last activity #{c.last_activity_date} "}
      expect(cards.size).to be > 0
      card.delete
    end
  end
