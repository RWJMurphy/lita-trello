module Lita
  module Handlers
    class Trello < Handler
      config :public_key
      config :token
      config :board

      route(
        /^trello\s+new\s+(?<list_name>(\w+|"[^"]+"))\s+(?<name>.*)/i,
        :new,
        command: true,
        help: {
          t('help.new.syntax') => t('help.new.desc')
        }
      )

      route(
        %r{^trello\s+move\s+https://trello.com/c/(?<card_id>\w+)\s+(?<list_name>(\w+|"[^"]+"))},
        :move,
        command: true,
        help: {
          t('help.move.syntax') => t('help.move.desc')
        }
      )

      route(
        /^trello\s+list\s+(?<list_name>(\w+|"[^"]+"))/i,
        :list,
        command: true,
        help: {
          t('help.list.syntax') => t('help.list.desc')
        }
      )

      route(
        /^trello\s+lists$/i,
        :show_lists,
        command: true,
        help: {
          t('help.lists.syntax') => t('help.lists.desc')
        }
      )

      def new(r)
        list_name = r.match_data['list_name']
        name = r.match_data['name']

        list_id = lists[list_name.downcase].id
        if list_id.nil?
          r.reply t('error.no_list', list_name: list_name)
          return
        end

        r.reply t('card.creating', user_name: r.user.name, list_name: list_name)
        begin
          card = new_card(name, list_id)
          r.reply t('card.created', url: card.short_url)
        rescue
          r.reply t('error.generic')
        end
      end

      def move(r)
        card_id = r.match_data['card_id']
        list_name = r.match_data['list_name']

        list = lists[list_name.downcase]
        if list.nil?
          r.reply t('error.no_list', list_name: list_name)
          return
        end

        card = trello.find(:card, card_id)
        if card.nil?
          r.reply t('error.no_card')
          return
        end

        begin
          card.move_to_list(list)
          r.reply t('card.moved', user_name: r.user.name, list_name: list_name)
        rescue
          r.reply t('error.generic')
        end
      end

      def list(r)
        list_name = r.match_data['list_name']
        list = lists[list_name.downcase]
        if list.nil?
          r.reply t('error.no_list', list_name: list_name)
          return
        end

        r.reply(t('card.list', list_name: list_name) +
                list.cards.map { |card| "* #{card.name} - #{card.short_url}" }.join("\n")
               )
      end

      def show_lists(r)
        r.reply(t('list.list') +
                lists.keys.map { |list_name| "* #{list_name}" }.join("\n")
               )
      end

      private

      def trello
        @trello ||= ::Trello::Client.new(
          developer_public_key: config.public_key,
          member_token: config.token
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

      def new_card(name, list_id = nil)
        trello.create(:card,
                      'name' => name,
                      'idList' => list_id || default_list_id
                     )
      end
    end

    Lita.register_handler(Trello)
  end
end
