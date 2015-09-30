require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'), __FILE__
)]

require 'trello'

require 'lita/handlers/trello'

Lita::Handlers::Trello.template_root File.expand_path(
  File.join('..', '..', 'templates'),
  __FILE__
)
