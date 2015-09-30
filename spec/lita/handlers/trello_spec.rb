require "spec_helper"

describe Lita::Handlers::Trello, lita_handler: true do
  it { is_expected.to route_command('trello new LIST Do the thing').to(:handle_create_card) }
  it { is_expected.to route_command('trello move https://trello.com/c/CARD_ID LIST').to(:handle_move_card) }
  it { is_expected.to route_command('trello list LIST').to(:handle_list_cards) }
  it { is_expected.to route_command('trello lists').to(:handle_lists) }

  before do
    registry.config.handlers.trello.public_key = 'foo'
    registry.config.handlers.trello.token = 'bar'
    registry.config.handlers.trello.board = 'baz'
  end

  let(:card) do
    card = double
    allow(card).to receive(:name) { 'cardname' }
    allow(card).to receive(:short_url) { 'http://example.com/cardshorturl' }
    allow(card).to receive(:move_to_list) { true }
    card
  end

  let(:list) do
    list = double
    allow(list).to receive(:name) { 'listname' }
    allow(list).to receive(:cards) { [card] }
    allow(list).to receive(:id) { 1 }
    list
  end

  let(:board) do
    board = double
    allow(board).to receive(:lists) { [list] }
    board
  end

  let(:client) do
    client = double
    allow(client).to receive(:find) { board }
    allow(client).to receive(:create) { card }
    client
  end

  describe '#handle_create_card' do
    it 'creates a card' do
      expect(::Trello::Client).to receive(:new) { client }
      send_command('trello new listname Do the thing')
      expect(replies.last).to eq('Here you go: http://example.com/cardshorturl')
    end
  end

  describe '#handle_move_card' do
    xit 'moves a card' do
      expect(::Trello::Client).to receive(:new) { client }
      send_command('trello move https://trello.com/c/CARD_ID listname')
      expect(replies.last).to eq("WHA")
    end
  end

  describe '#handle_list_cards' do
    it 'shows cards for a list' do
      expect(::Trello::Client).to receive(:new) { client }
      send_command('trello list listname')
      expect(replies.last).to eq("Here are the cards in listname:\n\n* cardname - http://example.com/cardshorturl")
    end

    it 'shows an error if there is no list' do
      expect(::Trello::Client).to receive(:new) { client }
      send_command('trello list badname')
      expect(replies.last).to eq("I couldn't find a list named badname.")
    end
  end

  describe '#handle_lists' do
    it 'shows lists' do
      expect(::Trello::Client).to receive(:new) { client }
      send_command('trello lists')
      expect(replies.last).to eq("Here are all the lists on your board:\n\n* listname")
    end
  end
end
