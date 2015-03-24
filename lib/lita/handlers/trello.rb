require 'trello'

module Lita
  module Handlers
    class Trello < Handler
      config :public_key
      config :token
      config :board

      route(/^trello\s+new\s+[^\s]+\s+[^\s]+/i, :handle_create_card, command: true, help: {
        "trello new LIST Do the thing" => "Create a new card in LIST called 'Do the thing'"
      })
      def handle_create_card(r)
        list_name = r.args[1]
        name = r.args[2..-1].join(" ")

        list_id = lists[list_name.downcase].id
        if list_id.nil?
          r.reply "I couldn't find a list named #{list_name}."
          return
        end

        r.reply "Ok #{r.user.name}, I'm creating a new card in #{list_name}."
        begin
          card = new_card(name, list_id)
          r.reply "Here you go: #{card.short_url}"
        rescue
          r.reply "Something failed."
        end
      end

      route(/^trello\s+move\s+[^\s]+\s+[^\s]+/i, :handle_move_card, command: true, help: {
        "trello move https://trello.com/c/CARD_ID LIST" => "Move a card to LIST"
      })
      def handle_move_card(r)
        card_id = r.args[1]
        list_name = r.args[2]

        list = lists[list_name.downcase]
        if list.nil?
          r.reply "I couldn't find a list named #{list_name}."
          return
        end

        card_id = card_id.gsub(/(^<|>$)/, '')
        if %r{^https?://trello.com/c/([^/]+)/?$} =~ card_id
          card_id = $1
        end

        card = trello.find(:card, card_id)
        if card.nil?
          r.reply "I couldn't find that card."
          return
        end

        begin
          card.move_to_list(list)
          r.reply "Ok #{r.user.name}, I moved that card to #{list_name}."
        rescue
          r.reply "Something failed."
        end
      end

      route(/^trello\s+list\s+[^\s]+/i, :handle_list_cards, command: true, help: {
        "trello list LIST" => "Show all cards in LIST"
      })
      def handle_list_cards(r)
        list_name = r.args[1]
        list = lists[list_name.downcase]
        if list.nil?
          r.reply "I couldn't find a list named #{list_name}."
          return
        end

        r.reply("Here are the cards in #{list.name}:\n\n" +
          list.cards.map { |card| "* #{card.name} - #{card.short_url}" }.join("\n")
        )
      end

      route(/^trello\s+lists$/i, :handle_lists, command: true, help: {
        "trello lists" => "Show all lists on your board"
      })
      def handle_lists(r)
        r.reply("Here are all the lists on your board:\n\n" +
          lists.keys.map { |list_name| "* #{list_name}" }.join("\n")
        )
      end

      private
      def trello
        @trello ||= ::Trello::Client.new(
          developer_public_key: config.public_key,
          member_token: config.token,
        )
      end

      def board
        @board ||= trello.find(:board, config.board)
      end

      def lists
        @lists ||= begin
          board.lists.map { |list| [list.name.downcase, list] }.to_h
        end
      end

      def default_list_id
        @default_list_id ||= redis.get('default_list_id')
      end

      def new_card(name, list_id=nil)
        trello.create(:card,
          'name' => name,
          'idList' => list_id || default_list_id,
        )
      end

    end

    Lita.register_handler(Trello)
  end
end
