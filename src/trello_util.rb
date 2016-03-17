require 'trello'

class TrelloUtil

  def initialize(board_id, api_key, member_token)
    Trello.configure do |config|
      config.developer_public_key = api_key # The "key" from step 1
      config.member_token = member_token # The token from step 3.
    end
    @board = Trello::Board.find(board_id)
  end

  def listCards()
    @board.cards
  end

  def getLists()
    @board.lists
  end

  def addCard(msg)
    list_id = @board.lists[0].id
    puts list_id
    card = Trello::Card.create(name: '1', list_id: list_id, desc: msg)
    puts card
    return card
  end

  def moveCard(card, to)
    @board.card(card).move(to)
  end

  def add_member(card_id, member_id)
    card = Trello::Card.find(card_id)
    card.add_member(member_id)
    return card
  end

  def remove_member(card_id, member_id)
    card = Trello::Card.find(card_id)
    card.remove_member(member_id)
    return card
  end

  def fetchCards(cardFilter)
    @board.cards.select &cardFilter
  end
end
